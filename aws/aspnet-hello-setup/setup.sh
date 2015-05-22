#!/bin/bash

sudo docker pull docker.io/adreeve/aspnet-hello:120f95addabb382f96df63d784a24e753b3132a7

sudo cp /tmp/aspnet-hello.service /etc/systemd/system/aspnet-hello.service

sudo systemctl enable aspnet-hello.service
sudo systemctl start aspnet-hello.service
