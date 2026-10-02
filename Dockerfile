FROM ubuntu:26.04

LABEL maintainer="Reinhard Pointner <rednoah@filebot.net>"


ENV FILEBOT_VERSION="5.3.0"


RUN set -eux \
 ## ** install dependencies
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-21-jre-headless libjna-java libchromaprint-tools trash-cli unzip unrar 7zip 7zip-rar xz-utils ffmpeg mkvtoolnix atomicparsley imagemagick webp libavif-bin libjxl-tools sudo git gnupg curl file tree inotify-tools rsync jdupes duperemove \
 ## ** remove large recommended dependencies that are not actually used
    mesa-vulkan-drivers- pocketsphinx-en-us- qt6-translations-l10n- adwaita-icon-theme- poppler-data- fonts-urw-base35- fonts-droid-fallback- fonts-dejavu-core- fonts-dejavu-mono- \
 ## ** install MediaInfo 26.05 or higher
 && curl -O https://mediaarea.net/repo/deb/repo-mediaarea_1.0-27_all.deb && dpkg -i repo-mediaarea_1.0-27_all.deb && rm -v repo-mediaarea_1.0-27_all.deb && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mediainfo \
 && rm -rvf /var/lib/apt/lists/* \
 ## ** FIX sudo because sudo-rs does not support the --preserve-env option
 && update-alternatives --set sudo /usr/bin/sudo.ws \
 ## ** FIX libjna-java (see https://bugs.launchpad.net/ubuntu/+source/libjna-java/+bug/2000863)
 && ln -s /usr/lib/*-linux-gnu*/jni /usr/lib/jni \
 ## ** print installed packages index
 && dpkg-query -W -f='${Installed-Size} ${Package}\n' | sort -n


RUN set -eux \
 ## ** install filebot
 && curl -fsSL "https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub" | gpg --dearmor --output "/usr/share/keyrings/filebot.gpg"  \
 && echo "deb [arch=all signed-by=/usr/share/keyrings/filebot.gpg] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends filebot \
 && rm -rvf /var/lib/apt/lists/* \
 ## ** generate CDS archive
 && java -Xshare:dump -XX:SharedClassListFile="/usr/share/filebot/jsa/classes.jsa.lst" -XX:SharedArchiveFile="/usr/share/filebot/jsa/classes.jsa" -jar "/usr/share/filebot/jar/filebot.jar" \
 ## ** apply custom application configuration
 && sed -i 's|APP_DATA=.*|APP_DATA="$HOME"|g; s|-Dapplication.deployment=deb|-Dapplication.deployment=docker -Duser.home="$HOME" -Dnet.filebot.UserFiles.trash=XDG -XX:SharedArchiveFile=/usr/share/filebot/jsa/classes.jsa|g' /usr/bin/filebot


# install custom launcher scripts
COPY generic /


ENV HOME="/data"
ENV LANG="C.UTF-8"

ENV PUID="1000"
ENV PGID="1000"
ENV PUSER="filebot"
ENV PGROUP="filebot"


ENTRYPOINT ["/opt/bin/run-as-user", "/opt/bin/run", "/usr/bin/filebot"]
