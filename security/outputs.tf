output "nginx_sg" {
  value = "${aws_security_group.nginx.id}"
}

output "app_sg" {
  value = "${aws_security_group.app.id}"
}
