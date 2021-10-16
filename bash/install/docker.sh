#!/bin/bash

source "$( dirname -- "${BASH_SOURCE[0]}" )"/is_root.sh

wget get.docker.com -O /tmp/install_docker.sh
chmod +x  /tmp/install_docker.sh
 /tmp/install_docker.sh

 systemctl enable --now docker

 systemctl status docker
