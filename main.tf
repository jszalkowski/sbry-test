provider "aws" {
    access_key =  "${var.aws_access_key}"
    secret_key =  "${var.aws_secret_access_key}"
    region = "${var.aws_region}"
}
module "vpc" {
  source = "./vpc"
        owner = "${var.owner}"
        project = "${var.project}"
        environment = "${var.environment}"
        costcentre = "${var.costcentre}"
        aws_region = "${var.aws_region}"
        vpc_cidr = "${var.vpc_cidr}"
        cidr_block = "${var.cidr_block}"
        external_access_cidr_block = "${var.external_access_cidr_block}"
        public_subnet_cidr_blocks = "${var.public_subnet_cidr_blocks}"
        private_subnet_cidr_blocks = "${var.private_subnet_cidr_blocks}"
        availability_zones = "${var.availability_zones}"
        wide_open = "${var.wide_open}"

}

module "security" {
	source = "./security"
        owner = "${var.owner}"
        project = "${var.project}"
        environment = "${var.environment}"
        costcentre = "${var.costcentre}"
	vpc_id	= "${module.vpc.vpc_id}"
        public_subnet_cidr_blocks = "${var.public_subnet_cidr_blocks}"
        private_subnet_cidr_blocks = "${var.private_subnet_cidr_blocks}"
	wide_open = "${var.wide_open}"
}


module "instances" {
        source = "./instances"
        owner = "${var.owner}"
        project = "${var.project}"
        environment = "${var.environment}"
        costcentre = "${var.costcentre}"
	vpc_id  = "${module.vpc.vpc_id}"
	public_subnets_id = "${module.vpc.public_subnets_id}"
	aws_key_name   = "${var.aws_key_name}"
	aws_key_path = "${var.aws_key_path}"
	ami_id	=	 "${lookup(var.ami_id, var.aws_region)}" 
	availability_zones = "${var.availability_zones}"
	aws_region = "${var.aws_region}"
	instance_type = "${var.instance_type}"
	nginx_sg	= "${module.security.nginx_sg}"
  	role_web		= "${var.role_web}"
}


module "lc" {
        source = "./lc"
        owner = "${var.owner}"
        project = "${var.project}"
        environment = "${var.environment}"
        costcentre = "${var.costcentre}"
        aws_region = "${var.aws_region}"	
	vpc_id  = "${module.vpc.vpc_id}"
        aws_key_name   = "${var.aws_key_name}"
        aws_key_path = "${var.aws_key_path}"
        ami_id  =        "${lookup(var.ami_id, var.aws_region)}"
	app_sg = "${module.security.app_sg}"
        instance_type = "${var.instance_type}"
        aws_key_name   = "${var.aws_key_name}"
}


module "asg" {
        source = "./asg"
        owner = "${var.owner}"
        project = "${var.project}"
        environment = "${var.environment}"
        costcentre = "${var.costcentre}"
        vpc_id  = "${module.vpc.vpc_id}"
        private_subnets_id = "${module.vpc.private_subnets_id}"
        aws_key_name   = "${var.aws_key_name}"
        aws_key_path = "${var.aws_key_path}"
        ami_id  =        "${lookup(var.ami_id, var.aws_region)}"
        availability_zones = "${var.availability_zones}"
        aws_region = "${var.aws_region}"
        instance_type = "${var.instance_type}"
        amax = "${var.amax}"
        amin = "${var.amin}"
	adesired = "${var.adesired}"
	lc_name = "${module.lc.lc_name}"
        lc_id = "${module.lc.lc_id}"
        role_app                = "${var.role_app}"
}

