FROM openjdk:13-alpine


MAINTAINER Reinhard Pointner <rednoah@filebot.net>


ENV FILEBOT_VERSION 4.8.6
ENV FILEBOT_URL https://get.filebot.net/filebot/BETA/FileBot_$FILEBOT_VERSION-portable.tar.xz
ENV FILEBOT_SHA256 fe26cd27fa77bc6e2fe183d7bd07f5574c1170f386acad555007262ea60a607f


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
