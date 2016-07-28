resource "aws_key_pair" "auth" {
  key_name   = "${var.aws_key_name}"
  public_key = "${file(var.aws_key_path)}"
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.nginx.id}"
  vpc      = true
}

resource "aws_iam_instance_profile" "lb_profile" {
  name  = "lb_profile"
  roles = ["${aws_iam_role.role.name}"]
}

resource "aws_iam_role_policy" "lb_policy" {
  name = "lb_policy"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "role" {
  name = "lb_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_instance" "nginx" {
  ami                         = "${var.ami_id}"
  availability_zone           = "${element(split(",", var.availability_zones), 0)}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.aws_key_name}"
  monitoring                  = true
  vpc_security_group_ids      = ["${var.nginx_sg}"]
  subnet_id                   = "${element(split(",", var.public_subnets_id), 0)}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.lb_profile.name}"
  user_data                   = "${file("./lc/userdata.sh")}"

  tags {
    Name        = "${var.project}-${var.environment}-nginxlb"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
    role        = "${var.role_web}"
  }
}
