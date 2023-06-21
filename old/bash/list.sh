#!/bin/bash

echo '
[1] - Install node exporter
[2] - Install node exporter
[3] - Install docker
'
read -p "Enter a number " selectedNumber

case "$1" in
        1)
            ./Install_node_exporter.sh
            ;;
        
        2)
            ./Install_prometheus.sh
            ;;
        
        3)
            ./Install_docker.sh
            ;;
        
        *)
            echo "Please enter only number that appears in list"
            exit 1
esac
