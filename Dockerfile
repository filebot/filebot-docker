FROM ubuntu:22.04

LABEL maintainer="Reinhard Pointner <rednoah@filebot.net>"


ENV FILEBOT_VERSION="5.1.6"


RUN set -eux \
 ## ** install dependencies
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-21-jre-headless libjna-java mediainfo libchromaprint-tools unzip unrar p7zip-full p7zip-rar xz-utils ffmpeg mkvtoolnix atomicparsley sudo gnupg curl file inotify-tools rsync jdupes duperemove \
 && rm -rvf /var/lib/apt/lists/* \
 ## ** FIX libjna-java (see https://bugs.launchpad.net/ubuntu/+source/libjna-java/+bug/2000863)
 && ln -s /usr/lib/*-linux-gnu*/jni /usr/lib/jni

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
 && sed -i 's|APP_DATA=.*|APP_DATA="$HOME"|g; s|-Dapplication.deployment=deb|-Dapplication.deployment=docker -Duser.home="$HOME" -XX:SharedArchiveFile=/usr/share/filebot/jsa/classes.jsa|g' /usr/bin/filebot


# install custom launcher scripts
COPY generic /


ENV HOME="/data"
ENV LANG="C.UTF-8"

ENV PUID="1000"
ENV PGID="1000"
ENV PUSER="filebot"
ENV PGROUP="filebot"


ENTRYPOINT ["/opt/bin/run-as-user", "/opt/bin/run", "/usr/bin/filebot"]
