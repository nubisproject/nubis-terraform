variable "account" {}

variable "region" {}

variable "environment" {}

variable "arena" {
  default = "core"
}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "purpose" {
  default = "nubis"
}

variable "swap_size_meg" {
  default = ""
}

variable "enabled" {
  default = 1
}

variable "service_name" {
  default = "nubis"
}

variable "consul_token" {
  default = "anonymous"
}

variable "nubis_sudo_groups" {
  default = "nubis_global_admins"
}

variable "nubis_user_groups" {
  default = ""
}
