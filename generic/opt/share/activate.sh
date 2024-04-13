#!/bin/sh


echo "
--------------------------------------------------------------------------------

Hello! Do you need help Getting Started?

# FAQ
https://www.filebot.net/linux/docker.html

# Read License Key from Console
docker run --rm -it -v data:/data -e PUID=$(id -u) -e PGID=$(id -g) rednoah/filebot --license

--------------------------------------------------------------------------------
"


if [ "$(id -u)" -eq 0 ]; then
echo '
	!!! YOU ARE RUNNING AS ROOT AND NOT AS NORMAL USER !!!
'
fi


echo "
# env
USER=$(id -un)($(id -u))
HOME=$HOME
"

