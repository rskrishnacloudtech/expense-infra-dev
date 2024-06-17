#!/bin/bash
component=$1
environment=$2
dnf install ansible -y
pip3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/rskrishnacloudtech/exp-ansible-roles-tf.git main.yml -e component=$component -e environment=$environment