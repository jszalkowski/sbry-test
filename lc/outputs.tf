output "lc_id" {
  value = "${aws_launch_configuration.app_lc.id}"
}

output "lc_name" {
  value = "${aws_launch_configuration.app_lc.name}"
}
