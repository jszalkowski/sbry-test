resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.project}-${var.environment}-VPC"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.project}-${var.environment}-GW"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_route" "route" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_subnet" "private" {
  count             = "${length(split(",", var.private_subnet_cidr_blocks))}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(split(",", var.private_subnet_cidr_blocks), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"

  tags {
    Name        = "${var.project}-${var.environment}-PRIVATE"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_subnet" "public" {
  count                   = "${length(split(",", var.public_subnet_cidr_blocks))}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(split(",", var.public_subnet_cidr_blocks), count.index)}"
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.project}-${var.environment}-PUBLIC"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(split(",", var.private_subnet_cidr_blocks))}"
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.ngw.*.id, count.index)}"
  }

  tags {
    Name        = "${var.project}-${var.environment}-rt-private"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name        = "${var.project}-${var.environment}-rt-public"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.private_subnet_cidr_blocks))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.public_subnet_cidr_blocks))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nat" {
  count = "${length(split(",", var.public_subnet_cidr_blocks))}"
  vpc   = true
}

resource "aws_nat_gateway" "ngw" {
  count         = "${length(split(",", var.public_subnet_cidr_blocks))}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]
}

resource "aws_security_group" "default" {
  name        = "${var.project}-VPC-SG"
  description = "Default Security Group for VPC"
  vpc_id      = "${aws_vpc.vpc.id}"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-PUBLIC"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    CostCentre  = "${var.costcentre}"
  }
}
