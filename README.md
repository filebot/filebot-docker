# FileBot Docker

Docker images for [FileBot](https://www.filebot.net/).
- [`filebot` (*Dockerfile*)](https://github.com/filebot/filebot-docker/blob/master/Dockerfile)
- [`filebot-node` (*Dockerfile*)](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.node)
- [`filebot-watcher` (*Dockerfile*)](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.watcher)


## filebot

The [`filebot`](https://www.filebot.net/cli.html) command-line tool.

```bash
docker run --rm -it -v $PWD:/volume1 -v data:/data rednoah/filebot -script fn:sysinfo
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot
    image: rednoah/filebot
    restart: unless-stopped
    volumes:
      - ${HOME}/FileBot:/data
      - ${HOME}/path/to/files:/volume1
```


## filebot-node

FileBot Node allows you to call the [amc script](https://www.filebot.net/amc.html) via a simple web interface.

```bash
docker run --rm -it -v $PWD:/volume1 -v data:/data -p 5452:5452 rednoah/filebot:node
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot-node:
    container_name: filebot-node
    image: rednoah/filebot:node
    restart: unless-stopped
    volumes:
      - ${HOME}/FileBot:/data
      - ${HOME}/path/to/files:/volume1
    ports:
      - 5452:5452
```

Once the [FileBot Node Service](https://github.com/filebot/filebot-node) is running, you can access the  web interface via [http://localhost:5452/filebot/](http://localhost:5452/filebot/). You can create prepared tasks via `Execute ➔ Schedule` and then execute them remotely via `curl http://localhost:5452/task?id=${TASK_ID}`.

You may secure the [FileBot Node Service](https://github.com/filebot/filebot-node) by using `HTTPS` and `BASIC` authentication:
```bash
docker run --rm -it -v $PWD:/volume1 -v data:/data -p 5452:5452 -e FILEBOT_NODE_AUTH=BASIC -e FILEBOT_NODE_AUTH_USER=alice -e FILEBOT_NODE_AUTH_PASS=wxy87rFb -p 5453:5453 -v /etc/ssl:/etc/ssl:ro -e FILEBOT_NODE_HTTPS=YES -e FILEBOT_NODE_HTTPS_PORT=5453 -e FILEBOT_NODE_HTTPS_KEY=/etc/ssl/private/server.key -e FILEBOT_NODE_HTTPS_CRT=/etc/ssl/certs/server.crt rednoah/filebot:node
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot-node:
    container_name: filebot-node
    image: rednoah/filebot:node
    restart: unless-stopped
    volumes:
      - '/etc/ssl:/etc/ssl:ro'
      - ${HOME}/FileBot:/data
      - ${HOME}/path/to/files:/volume1
    ports:
      - 5452:5452
      - 5453:5453
    environment:
      - FILEBOT_NODE_AUTH=BASIC
      - FILEBOT_NODE_AUTH_USER=alice
      - FILEBOT_NODE_AUTH_PASS=wxy87rFb
      - FILEBOT_NODE_HTTPS=YES
      - FILEBOT_NODE_HTTPS_PORT=5453
      - FILEBOT_NODE_HTTPS_KEY=/etc/ssl/private/server.key
      - FILEBOT_NODE_HTTPS_CRT=/etc/ssl/certs/server.crt
```


## filebot-watcher

The [`filebot-watcher`](https://github.com/filebot/filebot-docker/blob/master/filebot-watcher) command-line tool watches a given folder and executes the [amc script](https://www.filebot.net/amc.html) on newly added files.

```bash
docker run --rm -it -v $PWD:/volume1 -v data:/data rednoah/filebot:watcher /volume1/input --output /volume1/output
```
The first argument `$1` is the watch folder. The remaining arguments are [amc script](https://www.filebot.net/amc.html) options.

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot-watcher
    image: rednoah/filebot:watcher
    restart: unless-stopped
    command: /downloads --output /output #The remaining arguments are amc script options: https://www.filebot.net/amc.html
    volumes:
      - ${HOME}/FileBot:/data
      - ${HOME}/path/to/files:/volume1
```


# MOVE and HARDLINK
One of the requirements for hardlinking, is that the input/output must exist on the same filesystem. However, due to the way docker internally handles volume mounts, this can cause problems.

docker treats each volume mount, as a separate filesystem

In order for filebot to support hardlinking, it is recomended to use a single volume mount, that contains both your input/output files/directories.

With the following config, it is not possible to hardlink files located in `/downloads`, to `/output`
```
version: '3.3'
services:
  filebot:
    container_name: filebot
    image: rednoah/filebot
    restart: unless-stopped
    volumes:
      - ${HOME}/Filebot:/config
      - ${HOME}/Downloads:/downloads
      - ${HOME}/Output:/output
```

In order to solve this problem, it is recomended to create a single directory, that contains both `/downloads` and `/media` - then mount that directory.

`/home/user/Downloads`  
`/home/user/Output`  
  
would become  
  
`/home/user/Media`  
`/home/user/Media/Downloads`  
`/home/user/Media/Output`  
  
Then you would mount the Media folder inside your container.
```
version: '3.3'
services:
  filebot:
    container_name: filebot
    image: rednoah/filebot
    restart: unless-stopped
    volumes:
      - ${HOME}/Filebot:/config
      - ${HOME}/Media:/media
```

This will then allow you to hardlink between /Downloads and /Output, from within the docker container


# FAQ


## How do I activate my license?

You can activate your license by calling `filebot --license T1000.psm` from within the docker container.

```
docker run --rm -it -v $PWD:/volume1 -v data:/data rednoah/filebot --license /volume1/T1000.psm
```

Your license will then be stored in `-v data:/data` which is the persistent application data folder common to all FileBot docker containers.
