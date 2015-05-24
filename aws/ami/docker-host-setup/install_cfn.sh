#!/bin/bash

# Install Cloud Formation helper scripts
sudo yum -y install python-setuptools
sudo easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

sudo cp /tmp/cfn-hup.service /etc/systemd/system/cfn-hup.service

sudo systemctl enable cfn-hup.service
