output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets_id" {
  #   value = "${aws_subnet.public.0.id}"

  value = "${join(",", aws_subnet.public.*.id)}"
}

#output "public_subnet_ids" { value = "${split(",",join(",", aws_subnet.public.*.id))}" } 

output "private_subnets_id" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}
