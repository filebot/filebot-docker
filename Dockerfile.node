FROM rednoah/filebot

MAINTAINER Reinhard Pointner <rednoah@filebot.net>

ENV FILEBOT_NODE_VERSION 0.2.8.4
ENV FILEBOT_NODE_URL https://github.com/filebot/filebot-node/releases/download/$FILEBOT_NODE_VERSION/filebot-node-$FILEBOT_NODE_VERSION-generic.tar.xz
ENV FILEBOT_NODE_SHA256 b37c34216d1f201826fff6a8a9de4f5de0192ccffc3f4f4cfc467a7e14ec0c27


WORKDIR /usr/local/filebot-node


RUN apt-get update \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*


RUN curl -L -o filebot-node.tar.xz $FILEBOT_NODE_URL \
 && echo "$FILEBOT_NODE_SHA256 *filebot-node.tar.xz" | sha256sum --check --strict \
 && tar xvf filebot-node.tar.xz \
 && rm -rvf filebot-node.tar.xz \
 && find . -executable -type f -delete


COPY filebot-node filebot-node-task /usr/bin/


ENV FILEBOT_NODE_AUTH NONE

ENV FILEBOT_NODE_HTTP YES
ENV FILEBOT_NODE_HTTP_PORT 5452


EXPOSE $FILEBOT_NODE_HTTP_PORT

ENTRYPOINT ["/usr/bin/filebot-node"]
