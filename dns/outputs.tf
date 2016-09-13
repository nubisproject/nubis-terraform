output "fqdn" {
  value = "${coalesce(join(",",aws_route53_record.primary.*.fqdn), join(",",aws_route53_record.ipv4_alias.*.fqdn), join(",",aws_route53_record.ipv6_alias.*.fqdn))}"
}
