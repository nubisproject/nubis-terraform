variable "account" {}

variable "region" {}

variable "environment" {}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "service_name" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "health_check_target" {
  default = "HTTP:80/"
}

variable "health_check_timeout" {
  default = "3"
}

variable "health_check_healthy_threshold" {
  default = "2"
}

variable "health_check_unhealthy_threshold" {
  default = "2"
}

variable "ssl_cert_name_prefix" {
  default = ""
}

variable "no_ssl_cert" {
  default = "0"
}

variable "backend_protocol" {
  default = "http"
}

variable "backend_port_http" {
  default = "80"
}

variable "backend_port_https" {
  default = "80"
}

variable "port_http" {
  default = "80"
}

variable "port_https" {
  default = "443"
}

variable "protocol_http" {
  default = "http"
}

variable "protocol_https" {
  default = "https"
}

variable "internal" {
  default = false
}

variable "arena" {
  default = "core"
}

variable "idle_timeout" {
  default = "60"
}

variable "whitelist_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}
