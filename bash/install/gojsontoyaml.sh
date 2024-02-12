#!/bin/bash
cd /tmp/
rm -rf gojsontoyaml "gojsontoyaml*.tar.gz"
VER=$(curl -s https://api.github.com/repos/brancz/gojsontoyaml/releases/latest|grep tag_name|cut -d '"' -f 4|sed 's/v//')
wget https://github.com/brancz/gojsontoyaml/releases/download/v${VER}/gojsontoyaml_${VER}_darwin_amd64.tar.gz
wget https://github.com/brancz/gojsontoyaml/releases/download/v${VER}/gojsontoyaml_${VER}_linux_amd64.tar.gz
tar xvf gojsontoyaml_${VER}_darwin_amd64.tar.gz
sudo mv gojsontoyaml /usr/local/bin
