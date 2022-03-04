FROM ubuntu:20.04

LABEL maintainer="Reinhard Pointner <rednoah@filebot.net>"


ENV FILEBOT_VERSION 4.9.6


RUN set -eux \
 ## ** install dependencies
 && apt-get update \
 && apt-get install -y default-jre-headless libjna-java mediainfo libchromaprint-tools unrar p7zip-full p7zip-rar xz-utils mkvtoolnix atomicparsley sudo gnupg curl file inotify-tools \
 && rm -rvf /var/lib/apt/lists/*

RUN set -eux \
 ## ** install filebot
 && apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub  \
 && echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends filebot \
 && rm -rvf /var/lib/apt/lists/* \
 ## ** apply custom application configuration
 && sed -i 's/APP_DATA=.*/APP_DATA="$HOME"/g; s/-Dapplication.deployment=deb/-Dapplication.deployment=docker/g' /usr/bin/filebot

# install custom launcher scripts
COPY generic /


ENV HOME /data
ENV LANG C.UTF-8

ENV PUID 1000
ENV PGID 1000
ENV PUSER filebot
ENV PGROUP filebot


ENTRYPOINT ["/opt/bin/run-as-user", "/usr/bin/filebot"]
