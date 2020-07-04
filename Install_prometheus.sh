#!/bin/bash

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi


useradd -m -s /bin/bash prometheus
cd /home/prometheus

https://api.github.com/repos/prometheus/prometheus/releases/latest


downloadLink=`curl -sS https://api.github.com/repos/prometheus/prometheus/releases/latest |     grep -i \`uname -s\` | grep 'amd64' | grep download_url | cut -d'"' -f4`

wget $downloadLink -O /tmp/prometheus.tar.gz

prometheus_folder=`tar xzvf /tmp/prometheus.tar.gz | head -1`
tar xzvf /tmp/prometheus.tar.gz

mv $prometheus_folder/ /home/prometheus/prometheus
mkdir -p /home/prometheus/prometheus/data

chown prometheus. -R /home/prometheus/prometheus

echo '
[Unit]
Description=Prometheus Server
After=network-online.target

[Service]
User=prometheus
Restart=on-failure

ExecStart=/home/prometheus/prometheus/prometheus \
  --config.file=/home/prometheus/prometheus/prometheus.yml \
  --storage.tsdb.path=/home/prometheus/prometheus/data

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/prometheus.service

systemctl daemon-reload
systemctl enable --now prometheus

(netstat -nltp | grep :9090 && (clear && echo "Everything is OK")) || (clear && echo "There is some problems, please read this log" && journalctl -u prometheus)