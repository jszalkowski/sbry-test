resource "aws_security_group" "nginx" {
    name = "${var.project}-nginx"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.wide_open}"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["${var.wide_open}"]

    }
    ingress {
        from_port   = 8300
        to_port     = 8400
        protocol    = "tcp"
        cidr_blocks = ["${element(split(",", var.private_subnet_cidr_blocks), 0)}", "${element(split(",", var.private_subnet_cidr_blocks), 1)}", "${element(split(",", var.public_subnet_cidr_blocks), 0)}", "${element(split(",", var.public_subnet_cidr_blocks), 1)}"]
    }
    ingress {
        from_port   = 8300
        to_port     = 8400
        protocol    = "udp"
        cidr_blocks = ["${element(split(",", var.private_subnet_cidr_blocks), 0)}", "${element(split(",", var.private_subnet_cidr_blocks), 1)}", "${element(split(",", var.public_subnet_cidr_blocks), 0)}", "${element(split(",", var.public_subnet_cidr_blocks), 1)}"]

    }


egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  vpc_id = "${var.vpc_id}"
  tags {
    Name        = "${var.project}-${var.environment}-nginx"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_security_group" "app" {

    name = "${var.project}-app"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${element(split(",", var.private_subnet_cidr_blocks), 0)}", "${element(split(",", var.private_subnet_cidr_blocks), 1)}", "${element(split(",", var.public_subnet_cidr_blocks), 0)}", "${element(split(",", var.public_subnet_cidr_blocks), 1)}"]

    }
    ingress {
        from_port   = 8484
        to_port     = 8484
        protocol    = "tcp"
        cidr_blocks = ["${element(split(",", var.private_subnet_cidr_blocks), 0)}", "${element(split(",", var.private_subnet_cidr_blocks), 1)}", "${element(split(",", var.public_subnet_cidr_blocks), 0)}", "${element(split(",", var.public_subnet_cidr_blocks), 1)}"]
    }
    ingress {
        from_port   = 8300
        to_port     = 8400
        protocol    = "tcp"
        cidr_blocks = ["${element(split(",", var.private_subnet_cidr_blocks), 0)}", "${element(split(",", var.private_subnet_cidr_blocks), 1)}", "${element(split(",", var.public_subnet_cidr_blocks), 0)}", "${element(split(",", var.public_subnet_cidr_blocks), 1)}"]
    }
    ingress {
        from_port   = 8300
        to_port     = 8400
        protocol    = "udp"
        cidr_blocks = ["${element(split(",", var.private_subnet_cidr_blocks), 0)}", "${element(split(",", var.private_subnet_cidr_blocks), 1)}", "${element(split(",", var.public_subnet_cidr_blocks), 0)}", "${element(split(",", var.public_subnet_cidr_blocks), 1)}"]
    }

egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  vpc_id = "${var.vpc_id}"
  tags {
    Name        = "${var.project}-${var.environment}-app"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}
