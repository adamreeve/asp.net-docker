AMIs for running ASP.NET app
============================

This uses [packer](https://www.packer.io/) to build an AMI (Amazon Machine Image)
that runs an APS.NET vNext app and works with AWS autoscaling groups.

First build the base AMI for running docker containers:

```
    packer build \
        -var "aws_access_key=${AWS_ACCESS_KEY}" \
        -var "aws_secret_key=${AWS_SECRET_KEY}" \
        docker-host-ami.json
```

The `aspnet-hello-ami.json` file should have the `source_ami`
property set to the ami generated from `docker-host-ami.json`
above. Then build the ASP.NET app AMI:

```
    packer build \
        -var "aws_access_key=${AWS_ACCESS_KEY}" \
        -var "aws_secret_key=${AWS_SECRET_KEY}" \
        aspnet-hello-ami.json
```
