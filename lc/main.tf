resource "aws_iam_instance_profile" "goapp_profile" {
    name = "goapp_profile"
    roles = ["${aws_iam_role.role.name}"]
}


resource "aws_iam_role_policy" "goapp_policy" {
    name = "goapp_policy"
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
    name = "goapp_role"
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


resource "aws_launch_configuration" "app_lc" {
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.goapp_profile.name}"
  key_name                    = "${var.aws_key_name}"
  security_groups = [
    "${var.app_sg}",
  ]
  user_data = "${file("./lc/userdata.sh")}"
}
