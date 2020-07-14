#!/bin/bash

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi

rm -f /tmp/node_exporter.tar.gz
# uname -s -> Linux
# uname -i -> x86_64
# uname -i  | cut -d'_' -f2  -> 64

netstat -nltp | grep :9100 && (clear && echo "Node exporter already installed") && exit 0)

downloadLink=`curl -sS https://api.github.com/repos/prometheus/node_exporter/releases/latest |     grep -i \`uname -s\` | grep 'amd64' | grep download_url | cut -d'"' -f4`

wget $downloadLink -O /tmp/node_exporter.tar.gz

cd /tmp

node_exporter_folder=`tar xzvf node_exporter.tar.gz | head -1`
tar xzvf /tmp/node_exporter.tar.gz
cd $node_exporter_folder

mv node_exporter /usr/local/bin/
chmod +x /usr/local/bin/node_exporter

useradd -m -s /bin/bash prometheus

echo '
[Unit]
Description=Node Exporter
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=default.target' > /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl enable --now node_exporter

(netstat -nltp | grep :9100 && (clear && echo "Everything is OK")) || (clear && echo "There is some problems, please read this log" && journalctl -u node_exporter)