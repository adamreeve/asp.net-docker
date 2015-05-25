#!/bin/bash

sudo docker pull docker.io/adreeve/aspnet-hello:282952fd7318b5793bbf353778c358ce258af9d6

sudo cp /tmp/aspnet-hello.service /etc/systemd/system/aspnet-hello.service

sudo systemctl enable aspnet-hello.service
sudo systemctl start aspnet-hello.service
