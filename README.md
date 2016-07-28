SBRY-TEST
=============

#####Test is completed according to ''AWS'' Best practices

This repo contains 3 branches.



- **master**: Infrastructure is described using a terraform
- **cookbooks**: Chef cookbook used to automate deployment
- **goapp**: GO application that is served on app nodes


Each branch is used separately on different stages of deployment

About
-------------------------------
Infrastructure is constructed from :
- Dedicated VPC
- 2 Availability zones
- Public subnet (one per AZ)
- Private subnet (one per AZ)
- Nat gateways (one per AZ)
- Autoscaling group triggered by high cpu usage 
- 2 Instances within autoscaling group acting as web-app services (one per AZ) in a private subnet
- 1 Load balancer (nginx) in public subnet with assigned EIP acting also as bastion host (standalone instance)
- All resources are tagged 

![diagram](https://raw.githubusercontent.com/jszalkowski/sbry-test/master/cloud.png)

Terraform how-to
-------------------------------

**Terraform**: Each of the infrastructure resources is provisioned using terraform, main parts are split in to modules that are sharing outputs between themselves

**Configuration**: 
In order to deploy test to AWS account you must specify: 
- `aws_access_key`
- `aws_secret_access_key` 
- `aws_region`

In main configuration file **variables.tf**

**How to provision**: 
After it's configured just type 
$ ssh-keygen -q -t rsa -f ~/.ssh/sbry -N '' -C sbry
$ make
generate ssh key configure it in **variables.tf**
$ terraform get
$ terraform plan 
$ terraform apply 

**How to test**: 
After is provisioned terraform should print assigned EIP as its output
use given url in your browser to access the go application that is going to trigger the round-robin test.

Resources should be available within few minutes after terraform prints its output
