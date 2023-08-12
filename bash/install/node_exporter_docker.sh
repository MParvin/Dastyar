#!/bin/bash

# This is a script to install node exporter on docker

# Check docker is installed
which docker || ( echo "Docker is not installed, please install it first" && exit 1 )
deploy_path="/opt/src/node_exporter"
mkdir -p $deploy_path
cd $deploy_path

echo '
version: "3.7"
services:
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: always
    privileged: true
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - "--path.procfs=/host/proc"
      - "--path.rootfs=/rootfs"
      - "--path.sysfs=/host/sys"
      - "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)"
    ports:
        - 9100:9100
' > docker-compose.yml

# Check docker-compose is installed
(which docker-compose && docker-compose up -d ) || ( docker compose version && docker compose up -d ) || ( echo "Docker-compose is not installed, please install it first" && exit 1 )

# Check node exporter is running
curl -s http://localhost:9100/metrics || ( echo "Node exporter is not running, please check it" && exit 1 )
