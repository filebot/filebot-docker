FROM ubuntu:18.04

MAINTAINER Reinhard Pointner <rednoah@filebot.net>

RUN apt-get update \
 && apt-get install -y default-jre-headless libjna-java mediainfo libchromaprint-tools unrar p7zip-full p7zip-rar mkvtoolnix mp4v2-utils gnupg curl file inotify-tools \
 && rm -rvf /var/lib/apt/lists/*

RUN apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub  \
 && echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends filebot \
 && rm -rvf /var/lib/apt/lists/*

VOLUME /data
VOLUME /volume1

ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Duser.home=$HOME"

WORKDIR /volume1

ENTRYPOINT ["filebot"]
