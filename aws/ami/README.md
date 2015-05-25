AMIs for running ASP.NET app
============================

This uses [packer](https://www.packer.io/) to build an AMI (Amazon Machine Image)
that runs an APS.NET vNext app and works with AWS CloudFormation.

First build the base AMI for running docker containers,
which includes the CloudFormation utilities:

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

The AWS user that packer runs as should have the following policy
to allow AMI creation:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:CreateVolume",
                "ec2:DeleteVolume",
                "ec2:CreateKeypair",
                "ec2:DeleteKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteSecurityGroup",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateImage",
                "ec2:RunInstances",
                "ec2:TerminateInstances",
                "ec2:StopInstances",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:DescribeInstances",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:DescribeSnapshots",
                "ec2:DescribeImages",
                "ec2:RegisterImage",
                "ec2:CreateTags",
                "ec2:ModifyImageAttribute"
            ],
            "Resource": "*"
        }
    ]
}
```
