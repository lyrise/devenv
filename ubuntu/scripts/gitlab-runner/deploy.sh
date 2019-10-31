#! /bin/bash
# http://blog.programster.org/deploy-gitlab-runner-with-docker

docker pull gitlab/gitlab-runner:latest

docker run -d \
  --name gitlab-runner \
  --restart always \
  -v $HOME/gitlab-runner-volume/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
