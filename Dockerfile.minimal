FROM openjdk:14-alpine


MAINTAINER Reinhard Pointner <rednoah@filebot.net>


ENV FILEBOT_VERSION 4.9.2
ENV FILEBOT_URL https://get.filebot.net/filebot/FileBot_$FILEBOT_VERSION/FileBot_$FILEBOT_VERSION-portable.tar.xz
ENV FILEBOT_SHA256 9f12000925b46c46fff1297174e07590e7a1c1e4eab670ad4bec3b4051559e41


ENV FILEBOT_HOME /opt/filebot


# BROKEN PACKAGES
# mediainfo: Segmentation fault
# chromaprint: chromaprint (missing): required by: world[chromaprint]

RUN apk add --update p7zip unrar \
 && rm -rf /var/cache/apk/*

RUN set -eux \
 && wget -O /filebot.tar.xz "$FILEBOT_URL" \
 && echo "$FILEBOT_SHA256 */filebot.tar.xz" | sha256sum -c - \
 && mkdir -p "$FILEBOT_HOME" \
 && tar --extract --file /filebot.tar.xz --directory "$FILEBOT_HOME" --verbose \
 && rm /filebot.tar.xz


VOLUME /data
VOLUME /volume1

ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Dnet.filebot.archive.extractor=ShellExecutables -Duser.home=$HOME"

WORKDIR /volume1

ENTRYPOINT ["/opt/filebot/filebot.sh"]
