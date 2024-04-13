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


if [ "$EUID" -eq 0 ]; then
	echo -e '
	\033[38;5;202m
	!!! YOU ARE RUNNING AS ROOT AND NOT AS NORMAL USER !!!
	\033[0m
	'
fi


echo -e "
\033[38;5;40m
USER=$(id -un)($(id -u))
HOME=$HOME
\033[0m
"

