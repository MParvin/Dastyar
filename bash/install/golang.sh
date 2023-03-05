#!/bin/bash

# Get currnet shell name
shell_name=`echo $SHELL | awk -F '/' '{print $NF}'`
shell_rc=".$shell_name"rc
echo $shell_name
exit

name_version=`curl -sSL 'https://golang.org/VERSION?m=text'`

cd /tmp
wget https://golang.org/dl/$name_version.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go*.tar.gz

# set environment variables in $shell_rc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/$shell_rc
echo 'export GOPATH=$HOME/go' >> ~/$shell_rc
echo 'export GOROOT=/usr/local/go' >> ~/$shell_rc

source ~/$shell_rc

mkdir -p $GOPATH/{src,pkg,bin}
rm go*.tar.gz
