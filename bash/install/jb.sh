#!/bin/bash
rm -rf /tmp/jb
VER=$(curl -s https://api.github.com/repos/jsonnet-bundler/jsonnet-bundler/releases/latest|grep tag_name|cut -d '"' -f 4|sed 's/v//')
wget https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v${VER}/jb-linux-amd64 -O /tmp/jb
chmod +x /tmp/jb
sudo mv /tmp/jb /usr/local/bin
