# FileBot Docker

Docker images for [FileBot](https://www.filebot.net/).
- [`filebot` (*Dockerfile*)](https://github.com/filebot/plugins/blob/master/docker/Dockerfile)
- [`filebot-node` (*Dockerfile*)](https://github.com/filebot/plugins/blob/master/docker/Dockerfile.node)
- [`filebot-watcher` (*Dockerfile*)](https://github.com/filebot/plugins/blob/master/docker/Dockerfile.watcher)


## filebot

The [`filebot`](https://www.filebot.net/cli.html) command-line tool.

```
docker run --rm -it -v $PWD:/volume1 -v data:/data rednoah/filebot -script fn:sysinfo
```


## filebot-node

FileBot Node allows you to call the [amc script](https://www.filebot.net/forums/viewtopic.php?f=4&t=215) via a simple web interface.

```
docker run --rm -it -v $PWD:/volume1 -v data:/data -p 5452:5452 rednoah/filebot:node
```

Once the [FileBot Node Service](https://github.com/filebot/filebot-node) is running, you can access the  web interface via [http://localhost:5452/filebot/](http://localhost:5452/filebot/). You can create prepared tasks via `Execute ➔ Schedule` and then execute them remotely via `curl http://localhost:5452/task?id=${TASK_ID}`.

You may secure the [FileBot Node Service](https://github.com/filebot/filebot-node) by using `HTTPS` and `BASIC` authentication:
```
docker run --rm -it -v $PWD:/volume1 -v data:/data -p 5452:5452 -e FILEBOT_NODE_AUTH=BASIC -e FILEBOT_NODE_AUTH_USER=alice -e FILEBOT_NODE_AUTH_PASS=wxy87rFb -p 5453:5453 -v /etc/ssl:/etc/ssl:ro -e FILEBOT_NODE_HTTPS=YES -e FILEBOT_NODE_HTTPS_PORT=5453 -e FILEBOT_NODE_HTTPS_KEY=/etc/ssl/private/server.key -e FILEBOT_NODE_HTTPS_CRT=/etc/ssl/certs/server.crt rednoah/filebot:node
```


## filebot-watcher

The [`filebot-watcher`](https://github.com/filebot/plugins/blob/master/docker/filebot-watcher) command-line tool watches a given folder and executes the [amc script](https://www.filebot.net/forums/viewtopic.php?f=4&t=215) on newly added files.

```
docker run --rm -it -v $PWD:/volume1 -v data:/data rednoah/filebot:watcher /volume1/input --output /volume1/output
```

The first argument `$1` is the watch folder. The remaining arguments are [amc script](https://www.filebot.net/forums/viewtopic.php?f=4&t=215) options.


# FAQ


## How do I activate my license?

You can activate your license by calling `filebot --license *.psm` from within the docker container.

```
docker run --rm -it -v $PWD:/volume1 -v data:/data rednoah/filebot --license /volume1/*.psm
```

Your license will then be stored in `-v data:/data` which is the persistent application data folder common to all FileBot docker containers.
