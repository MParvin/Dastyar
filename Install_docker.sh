#!/bin/bash
if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi

wget get.docker.com -O /tmp/install_docker.sh
chmod +x  /tmp/install_docker.sh
 /tmp/install_docker.sh

 systemctl enable --now docker

 systemctl status docker
