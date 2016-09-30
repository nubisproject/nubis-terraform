variable "account" {}

variable "region" {}

variable "environment" {}

variable "service_name" { }
variable "storage_name" { }

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "client_security_groups" {}
