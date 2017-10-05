output "address" {
  value = "localhost:8500"
}

output "scheme" {
  value = "http"
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
