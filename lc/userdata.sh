#!/bin/sh

if ! chef-solo -v > /dev/null 2>&1; then
     sudo locale-gen en_GB.UTF-8
    export DEBIAN_FRONTEND=noninteractive
    apt-get update &&
    apt-get install -y ruby2.3 ruby2.3-dev build-essential awscli jq &&
    cd /tmp/ && wget  https://packages.chef.io/stable/ubuntu/10.04/chef_12.6.0-1_amd64.deb
    dpkg -i chef_12.6.0-1_amd64.deb && rm -f chef_12.6.0-1_amd64.deb
    cd /etc/
    git clone https://github.com/jszalkowski/sbry-test.git /etc/chef
fi
apt-get update &&
ROLE=$(aws ec2 describe-tags --filters   "Name=resource-type,Values=instance"   "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"   "Name=key,Values=role"  --region eu-west-1  | jq -r .Tags[].Value)
echo $ROLE>/etc/role
chef-solo -c /etc/chef/client.rb -j /etc/chef/roles/$ROLE.json
echo "ALL DONE"

