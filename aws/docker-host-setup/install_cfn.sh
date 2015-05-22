#!/bin/bash

# Install Cloud Formation helper scripts
sudo yum -y install python-setuptools
sudo easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
