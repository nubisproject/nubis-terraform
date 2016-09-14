output "address" {
  value = "public.consul.${var.environment}.${var.region}.${var.account}.${var.nubis_domain}:443"
}

output "scheme" {
  value = "https"
}

output "datacenter" {
  value = ""
}

output "prefix" {
  value = "${var.service_name}-${var.environment}/${var.environment}"
}

output "config_prefix" {
  value = "${var.service_name}-${var.environment}/${var.environment}/config"
}
