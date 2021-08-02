FROM ubuntu:20.04

LABEL maintainer="Reinhard Pointner <rednoah@filebot.net>"


ENV FILEBOT_VERSION 4.9.4


RUN apt-get update \
 && apt-get install -y default-jre-headless libjna-java mediainfo libchromaprint-tools unrar p7zip-full p7zip-rar mkvtoolnix atomicparsley gnupg curl file inotify-tools \
 && rm -rvf /var/lib/apt/lists/*

RUN apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub  \
 && echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends filebot \
 && rm -rvf /var/lib/apt/lists/*

RUN sed -i 's/-Dapplication.deployment=deb/-Dapplication.deployment=docker -Duser.home="$HOME"/g' /usr/bin/filebot


ENV HOME /data
ENV LANG C.UTF-8


ENTRYPOINT ["filebot"]
