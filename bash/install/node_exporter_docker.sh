#!/bin/bash

# This is a script to install gitlab runner on docker
# Path: bash/install/gitlab_runner_docker.sh

# Check docker is installed
which docker || ( echo "Docker is not installed, please install it first" && exit 1 )

mkdir -p /opt/src/gitlab-runner
cd /opt/src/gitlab-runner

echo '
version: "3.7"
services:
  gitlab-runner:
    image: gitlab/gitlab-runner:latest
    container_name: gitlab-runner
    restart: always
    privileged: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /srv/gitlab-runner/config:/etc/gitlab-runner
      - /opt/src/gitlab-runner:/home/gitlab-runner
    ports:
        - 9100:9100
' > docker-compose.yml

# Check docker-compose is installed
(which docker-compose && docker-compose up -d ) || ( docker compose version && docker compose up -d ) || ( echo "Docker-compose is not installed, please install it first" && exit 1 )

# Check node exporter is running
curl -s http://localhost:9100/metrics || ( echo "Node exporter is not running, please check it" && exit 1 )
