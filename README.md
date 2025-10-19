# FileBot Docker

Docker images for [FileBot](https://www.filebot.net/).
- [`filebot`](#filebot) command-line tool ([Dockerfile](https://github.com/filebot/filebot-docker/blob/master/Dockerfile))
- [`filebot-node`](#filebot-node) web application ([Dockerfile](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.node))
- [`filebot-watcher`](#filebot-watcher) command-line tool ([Dockerfile](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.watcher))
- [`filebot-xpra`](#filebot-xpra) remote desktop environment ([Dockerfile](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.xpra))
- [`filebot-projector`](#filebot-projector) web renderer ([Dockerfile](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.projector))
- [`filebot-webdav`](#filebot-webdav) webdav server ([Dockerfile](https://github.com/filebot/filebot-docker/blob/master/Dockerfile.webdav))

## filebot

The [`filebot`](https://www.filebot.net/cli.html) command-line tool.

```bash
# Run `filebot -script fn:sysinfo`
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" rednoah/filebot -script fn:sysinfo
```
```bash
# Run `filebot --license`
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" rednoah/filebot --license
```
```bash
# Run `filebot -rename -r . --format {plex.id}`
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" rednoah/filebot -rename -r /volume1 --format {plex.id}
```
```bash
# Run `filebot -script fn:amc ./input --output ./output --action duplicate -non-strict --log-file amc.log --def excludeList=amc.txt`
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" rednoah/filebot -script fn:amc /volume1/input --output /volume1/output --action duplicate -non-strict --log-file amc.log --def excludeList=amc.txt
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot
    image: rednoah/filebot
    volumes:
      - data:/data
      - /path/to/files:/volume1
    command: -script fn:sysinfo
volumes:
  data:
    name: filebot-application-data
```


## filebot-node

FileBot Node allows you to call the [amc script](https://www.filebot.net/amc.html) via a simple web interface.

```bash
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" -p 5452:5452 rednoah/filebot:node
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot-node:
    container_name: filebot-node
    image: rednoah/filebot:node
    hostname: filebot-node
    restart: unless-stopped
    volumes:
      - data:/data
      - /path/to/files:/volume1
    ports:
      - 5452:5452
volumes:
  data:
    name: filebot-application-data
```

Once the [FileBot Node Service](https://github.com/filebot/filebot-node) is running, you can access the  web interface via [http://localhost:5452/filebot/](http://localhost:5452/filebot/). You can create prepared tasks via `Execute ➔ Schedule` and then execute them remotely via `curl http://localhost:5452/task?id=${TASK_ID}`.

You may secure the [FileBot Node Service](https://github.com/filebot/filebot-node) by using `HTTPS` and `BASIC` authentication:
```bash
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" -e FILEBOT_NODE_AUTH=BASIC -e FILEBOT_NODE_AUTH_USER=YOUR_USERNAME -e FILEBOT_NODE_AUTH_PASS=YOUR_PASSWORD -p 5452:5452 -v /etc/ssl:/etc/ssl:ro -e FILEBOT_NODE_HTTPS=YES -e FILEBOT_NODE_HTTPS_PORT=5453 -e FILEBOT_NODE_HTTPS_KEY=/etc/ssl/private/server.key -e FILEBOT_NODE_HTTPS_CRT=/etc/ssl/certs/server.crt -p 5453:5453 rednoah/filebot:node
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot-node:
    container_name: filebot-node
    image: rednoah/filebot:node
    hostname: filebot-node
    restart: unless-stopped
    volumes:
      - data:/data
      - /path/to/files:/volume1
      - /etc/ssl:/etc/ssl:ro
    ports:
      - 5452:5452
      - 5453:5453
    environment:
      - FILEBOT_NODE_AUTH=BASIC
      - FILEBOT_NODE_AUTH_USER=YOUR_USERNAME
      - FILEBOT_NODE_AUTH_PASS=YOUR_PASSWORD
      - FILEBOT_NODE_HTTPS=YES
      - FILEBOT_NODE_HTTPS_PORT=5453
      - FILEBOT_NODE_HTTPS_KEY=/etc/ssl/private/server.key
      - FILEBOT_NODE_HTTPS_CRT=/etc/ssl/certs/server.crt
volumes:
  data:
    name: filebot-application-data
```
![FileBot Node](https://github.com/filebot/docs/raw/master/screenshots/docker-node.png)


## filebot-watcher

The [`filebot-watcher`](https://github.com/filebot/filebot-docker/blob/master/watcher/opt/bin/filebot-watcher) command-line tool watches a given folder and executes the [amc script](https://www.filebot.net/amc.html) on newly added files. Please read the [manual](https://www.filebot.net/forums/viewtopic.php?t=13038) for details and watch the [video tutorial](https://www.youtube.com/watch?v=AjP-ci9Cx5Q) to see it in action.

```bash
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" rednoah/filebot:watcher /volume1/input --output /volume1/output
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
    volumes:
      - data:/data
      - /path/to/files:/volume1
    command: /volume1/input --output /volume1/output # see amc script usage
volumes:
  data:
    name: filebot-application-data
```


## filebot-xpra

Run the [FileBot Desktop application](https://www.filebot.net/getting-started/) via [xpra](https://xpra.org/) and make it remotely available at [http://localhost:5454/](http://localhost:5454/).

```bash
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" -e XPRA_AUTH="password:value=YOUR_PASSWORD" -p 5454:5454 rednoah/filebot:xpra
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot-xpra
    image: rednoah/filebot:xpra
    hostname: filebot-xpra
    restart: "no"
    volumes:
      - data:/data
      - /path/to/files:/volume1
    ports:
      - 5454:5454
    environment:
      - XPRA_AUTH=password:value=YOUR_PASSWORD
volumes:
  data:
    name: filebot-application-data
```
Please read [How do I run the FileBot Desktop application on my Synology NAS or QNAP NAS?](https://www.filebot.net/forums/viewtopic.php?t=14884) for detailed setup instructions for `Synology NAS` and `QNAP NAS` devices.

![Xpra Remote Desktop (native client)](https://github.com/filebot/docs/raw/master/screenshots/docker-xpra-win.avif)
![Xpra Remote Desktop (HTML5 client)](https://github.com/filebot/docs/raw/master/screenshots/docker-xpra-web.avif)

If the clipboard does not work, then you may need to enable `Clipboard` permissions. If `CTRL+V` does not work, then you may need to use `Right-Click ➔ Paste` to paste text from the system clipboard:
![Xpra Remote Desktop - Enable Copy & Paste](https://raw.githubusercontent.com/filebot/docs/master/screenshots/filebot-xpra-clipboard.png)

If you have a `Reverse Proxy` that takes care of SSL and authentication, then you can disable authentication via `-e XPRA_AUTH=none` and disable remote access via `-e XPRA_BIND=127.0.0.1`.


## filebot-projector

Run the [FileBot Desktop application](https://www.filebot.net/getting-started/) via [JetBrains Projector](https://github.com/JetBrains/projector-server) and make it remotely available at [http://localhost:8887/](http://localhost:8887/).

```bash
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" -p 8887:8887 rednoah/filebot:projector
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot-projector
    image: rednoah/filebot:projector
    hostname: filebot-projector
    restart: unless-stopped
    volumes:
      - data:/data
      - /path/to/files:/volume1
    ports:
      - 8887:8887
volumes:
  data:
    name: filebot-application-data
```


## filebot-webdav

Run an [Apache WebDAV Server](https://httpd.apache.org/docs/2.4/mod/mod_dav.html) for remote file system access via [http://localhost:8080/](http://localhost:8080/).

```bash
docker run --rm -it -v "$PWD:/volume1" -e USERNAME=alice -e PASSWORD=secret1234 -p 8080:8080 rednoah/filebot:webdav
```

```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot-webdav
    image: rednoah/filebot:webdav
    restart: unless-stopped
    volumes:
      - /path/to/files:/volume1
    ports:
      - 8080:8080
    environment:
      - USERNAME=alice
      - PASSWORD=secret1234
volumes:
  data:
    name: filebot-application-data
```
![Map Network Drive via HTTP WebDAV](https://github.com/filebot/docs/raw/master/screenshots/filebot-webdav-map-network-drive.png)



# FAQ


## How do I activate my license?

If you are using the [`filebot-xpra`](#filebot-xpra) container, please install your license key via the `Select License File` button in the GUI as usual:

![Paste License Key](https://i.imgur.com/Ug8FHnV.png)

If you are using the [`filebot-node`](#filebot-node) container, please install your license key via the `Tools ➔ License` button in the WebUI as usual:

![Tools ➔ License](https://i.imgur.com/mQGgEKt.png)


Alternatively, you can activate your license by calling `filebot --license` from within the docker container:
```bash
# Read License Key from Console Input
docker run --rm -it -v "data:/data" rednoah/filebot --license
```
```bash
# Read License Key from License File
docker run --rm -it -v "data:/data" -v "$PWD:/volume1" rednoah/filebot --license /volume1/T1000.psm
```
Your license will then be stored in `-v data:/data` (i.e. named persistent volume `data` mapped as `/data` in the container file system) which is the persistent application data folder. All your FileBot docker containers must therefore use the same `data:/data` volume mount so that they can share the same application data folder. Please read [Run your app in production ➔ Manage application data ➔ Volumes](https://docs.docker.com/storage/volumes/) for details.

If you use `-e PUID` or `-e PGID` to run `filebot` with a different UID then you must use the same `-e PUID` or `-e PGID` environment variables when calling `filebot --license` to install the your license key into the correct user-specific application data folder. **DO NOT** open a shell to a running container to call `filebot --license` because your shell will be running as `root(0)` and **not** as `filebot(PUID)` user.

Alternatively, you can map your license file into the container at the expected file path directly via your launch configuration:
```sh
docker run --rm -it -v "data:/data" -v "/path/to/FileBot_License_P12345678.psm:/data/filebot/license.txt" -v "/path/to/files:/volume1" rednoah/filebot -script fn:sysinfo
```
```yml
# docker-compose.yml
version: '3.3'
services:
  filebot:
    container_name: filebot
    image: rednoah/filebot
    volumes:
      - data:/data
      - /path/to/FileBot_License_P12345678.psm:/data/filebot/license.txt
      - /path/to/files:/volume1
    command: -script fn:sysinfo
volumes:
  data:
    name: filebot-application-data
```


## How do I enter my OpenSubtitles login details?

You can enter your OpenSubtitles login details by calling `filebot -script fn:configure` from within the docker container.
```bash
# Read login details from Console Input
docker run --rm -it -v "data:/data" rednoah/filebot -script fn:configure
```
```bash
# Pass login details via Command-line Arguments
docker run --rm -it -v "data:/data" rednoah/filebot -script fn:configure --def osdbUser=USERNAME --def osdbPwd=PASSWORD
```
Your user settings will then be stored in `-v data:/data` (i.e. named persistent volume `data` mapped as `/data` in the container file system) which is the persistent application data folder. All your FileBot docker containers must therefore use the same `data:/data` volume mount so that they can share the same application data folder.


## How to do I run the process inside the container as a different user?

You can set the environment variables `PUID` and `PGID` to run the process with the given `UID`:
```bash
-e PUID=1000 -e PGID=1000
```
```yml
environment:
  - PUID=1000
  - PGID=1000
```
You may use `PUID=0` to run as default `root` user or docker `--user`:
```bash
docker run --rm -it -v "data:/data" -e PUID=0 -e PGID=0 rednoah/filebot -script fn:sysinfo
```


## How do I start an interactive shell session inside the container?

You can use the `--entrypoint` option to run `bash` on startup:
```
$ docker run --rm -it -v "data:/data" -v "$PWD:/volume1" -e PUID=1000 -e PGID=1000 --entrypoint /opt/bin/run-as-user rednoah/filebot bash
filebot@dcc9dbeac18d:/$ filebot -version
FileBot 4.9.6 (r9125)
```


## Notes on `--action MOVE` and `--action HARDLINK`

`docker` treats each volume mount as a separate filesystem. Thus, if you are using `--action MOVE` or `--action HARDLINK` then the input path and the output path must be on the same volume mount. If you process files across volume mounts, then `--action HARDLINK` will fail with `I/O error: cross-device link`, and `--action MOVE` and `--action DUPLICATE` will resort to physically copying files.

Please organize your files like so, and then use `/path/to/files` as single volume mount:
```
/path/to/files/input
/path/to/files/output
```
```bash
-v /path/to/files:/volume1
```
```yml
volumes:
  - /path/to/files:/volume1
```
