#!/bin/bash

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi

apt update -y && apt install -y nginx jq

grafanaVersion=`curl -sS https://api.github.com/repos/grafana/grafana/releases/latest | jq .tag_name`
debFile="grafana_`echo $grafanaVersion | sed 's/v//g' | sed 's/"//g'`_amd64.deb"
grafanaUrl="https://dl.grafana.com/oss/release/$debFile"

wget $grafanaUrl -O /tmp/$debFile

dpkg -i /tmp/$debFile || apt install -f -y

sed -i 's/;http_addr \=/http_addr = 127.0.0.1/g' /etc/grafana/grafana.ini

systemctl enable --now grafana-server

unlink /etc/nginx/sites-enabled/default
read -p "Enter site name or leave blank to set default: " siteName

if [ -z $siteName ]
then
siteName='_'
mkdir -p /backup/
tar czvf /backup/nginx_folder.tar.gz /etc/nginx/
unlink /etc/nginx/sites-enabled/default || unlink /etc/nginx/conf.d/default
configFile="grafana.conf"
else
configFile="$siteName.conf"
fi

echo "
server {
     listen 80;

     server_name $siteName;

     location / {
         proxy_pass http://localhost:3000;
         proxy_http_version 1.1;
     }
}" > "/etc/nginx/conf.d/$configFile.conf"

nginx -t && nginx -s reload

((netstat -nltp | grep :80 && netstat -nltp | grep :3000 ) && (clear && echo "Everything is ok")) || (clear && echo "There is a problem in installation" && exit 1)