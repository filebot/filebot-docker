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


echo "
\033[38;5;214m
# env
USER=$(id -un)($(id -u))
HOME=$HOME
\033[0m
"


if [ "$(id -u)" -eq 0 ]; then
echo "
\033[38;5;196m
	!!! YOU ARE RUNNING AS ROOT AND NOT AS NORMAL USER !!!
\033[0m
"
fi


if [ ! -d "$HOME" ] || [ "$(stat --file-system --format '%T' "$HOME")" = 'overlayfs' ]; then
echo "
\033[38;5;196m
	!!! YOU DID NOT BIND MOUNT $HOME TO A PERSISTENT HOST FOLDER !!!

	All data stored to the application data folder \`$HOME\` will be lost on container shutdown, like tears in rain.
	Please add \`-v data:/data\` to your \`docker\` command lest your application data, such as license key, be lost in time.
\033[0m
"
fi
