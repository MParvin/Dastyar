#!/bin/bash

source "$( dirname -- "${BASH_SOURCE[0]}" )"/is_root.sh

# ToDo: add other archtiectures (arm and x86) 

wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

chmod +x /usr/local/bin/gitlab-runner

useradd --comment "Gitlab runner" --create-home gitlab_runner --shell /bin/bash

gitlab-runner install --user=gitlab_runner --working-directory=/home/gitlab_runner

gitlab-runner start
