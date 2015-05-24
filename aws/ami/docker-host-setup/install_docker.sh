#!/bin/bash

sudo yum -y install docker-io
sudo systemctl enable docker
sudo systemctl start docker

# Install systemd-docker to  make running docker
# containers under systemd more sane:
sudo mkdir -p /opt/systemd-docker/bin
sudo curl -L -o /opt/systemd-docker/bin/systemd-docker https://github.com/ibuildthecloud/systemd-docker/releases/download/v0.2.0/systemd-docker
sudo chmod 755 /opt/systemd-docker/bin/systemd-docker
