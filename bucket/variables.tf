variable "account" {}

variable "region" {}

variable "environment" {}

variable "service_name" {}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "purpose" {}

variable "role" {}

variable "role_cnt" {
  default = 1
}
