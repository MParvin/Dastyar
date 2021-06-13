#!/bin/bash

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi

which netstat || (echo "Need to install netstat for check ports" && exit 1) # TODO: create a script for install all dependencies on server like netstat, vim

rm -f /tmp/phpfpm_exporter.tar.gz
# uname -s -> Linux
# uname -i -> x86_64
# uname -i  | cut -d'_' -f2  -> 64

netstat -nltp | grep :9253 && echo "PHPFPM exporter already installed" && exit 2

downloadLink=`curl -sS https://api.github.com/repos/Lusitaniae/phpfpm_exporter/releases/latest | grep -i \`uname -s\` | grep 'amd64' | grep download_url | cut -d'"' -f4`

wget $downloadLink -O /tmp/phpfpm_exporter.tar.gz

cd /tmp

phpfpm_exporter_folder=`tar xzvf phpfpm_exporter.tar.gz | head -1`
tar xzvf /tmp/phpfpm_exporter.tar.gz
cd $phpfpm_exporter_folder

mv phpfpm_exporter /usr/local/bin/
chmod +x /usr/local/bin/phpfpm_exporter

useradd -m -s /bin/bash prometheus

echo '
[Unit]
Description=FPM Exporter
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/phpfpm_exporter
Restart=on-failure

[Install]
WantedBy=default.target' > /etc/systemd/system/phpfpm_exporter.service

systemctl daemon-reload
systemctl enable --now phpfpm_exporter

(netstat -nltp | grep :9253 && echo "Everything is OK") || (echo "There is some problems, please read this log" && journalctl -u phpfpm_exporter)
