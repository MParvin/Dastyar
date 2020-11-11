#!/bin/bash

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi

which docker-compose && (echo "docker-compose already installed" && exit 1)

downloadLink=`curl -sS https://api.github.com/repos/docker/compose/releases/latest | grep -i \`uname -s\` | grep \`uname -i\` | grep download_url | cut -d'"' -f4 | head -1`

wget $downloadLink -O /usr/local/bin/docker-compose || (echo "Cannot download docker-compose" && exit 1)

chmod +x /usr/local/bin/docker-compose

which docker-compose || (clear && echo "docker-compose installation failed" && exit 1)
