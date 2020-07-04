#!/bin/bash

echo '
1 - Install node exporter
'
read -p "Enter a number " selectedNumber

case "$1" in
        1)
            ./Install_node_exporter.sh
            ;;
        
        *)
            echo "Please enter only number that appears in list"
            exit 1
esac
