output "address" {
  value = "dualstack.${aws_elb.load_balancer.dns_name}"
}

output "ipv4_address" {
  value = "${aws_elb.load_balancer.dns_name}"
}

output "ipv6_address" {
  value = "ipv6.${aws_elb.load_balancer.dns_name}"
}

output "name" {
  value = "${aws_elb.load_balancer.name}"
}
