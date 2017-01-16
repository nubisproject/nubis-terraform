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

variable "health_check_healthy_treshold" {
  default = "2"
}

variable "health_check_unhealthy_treshold" {
  default = "2"
}

variable "ssl_cert_name_prefix" {
  default = ""
}

variable "client_ptorocol" {
  default = "http"
}

variable "protocol_http" {
  default = "http"
}

variable "protocol_https" {
  default = "https"
}
