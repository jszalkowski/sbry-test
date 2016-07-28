
SBRY-TEST
=============

#####Test is completed according to ''AWS'' Best practices

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
```
$ make
```
or
generate ssh key configure it in **variables.tf**
```
$ terraform get
$ terraform plan 
$ terraform apply 
```

**How to test**: 
After is provisioned terraform should print assigned EIP as its output
use given url in your browser to access the go application that is going to trigger the round-robin test.

Resources should be available within few minutes after terraform prints its output
=======
Cookbooks 
--------------

This branch contains sbry cookbook

- **sbry::consul** installs and configures consul
- **sbry::consul-template** installs and configures consul-template 
- **sbry::goapp** installs and configures go application
- **sbry::lb** installs and configures nginx lb


