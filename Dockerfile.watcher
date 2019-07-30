FROM rednoah/filebot

MAINTAINER Reinhard Pointner <rednoah@filebot.net>

COPY filebot-watcher /usr/bin/filebot-watcher

ENV SETTLE_DOWN_TIME 600

ENTRYPOINT ["/usr/bin/filebot-watcher"]
