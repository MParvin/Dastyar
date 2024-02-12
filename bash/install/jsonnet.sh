#!/bin/bash
cd /tmp/
rm -rf /tmp/jsonnet /tmp/jsonnetfmt
VER=$(curl -s https://api.github.com/repos/google/go-jsonnet/releases/latest|grep tag_name|cut -d '"' -f 4|sed 's/v//')
wget https://github.com/google/go-jsonnet/releases/download/v${VER}/go-jsonnet_${VER}_Linux_x86_64.tar.gz
tar xvf go-jsonnet_${VER}_Linux_x86_64.tar.gz
sudo mv /tmp/jsonnet /tmp/jsonnetfmt /usr/local/bin

