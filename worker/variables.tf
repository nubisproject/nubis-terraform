variable "account" {}

variable "region" {}

variable "environment" {}

variable "arena" {
  default = "core"
}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "ami" {}

variable "enabled" {
  default = 1
}

variable "instance_type" {
  default = "t2.nano"
}

variable "service_name" {
  default = "nubis"
}

variable "purpose" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "ssh_key_name" {
  default = "nubis"
}

variable "ssh_key_file" {
  default = ""
}

variable "consul_token" {
  default = "anonymous"
}

variable "min_instances" {
  default = 1
}

variable "max_instances" {
  default = ""
}

variable "security_group" {
  default = ""
}

variable "security_group_custom" {
  default = false
}

variable "nubis_version" {
  default = ""
}

variable "wait_for_capacity_timeout" {
  default = "10m"
}

variable "health_check_type" {
  default = ""
}

variable "health_check_grace_period" {
  default = "300"
}

variable "elb" {
  default = ""
}

variable "instance_profile" {
  default = ""
}

variable "role" {
  default = ""
}

variable "monitoring" {
  default = "0"
}

variable "scale_load_defaults" {
  default = false
}

variable "scale_up_load" {
  default = ""
}

variable "scale_down_load" {
  default = ""
}

variable "nubis_sudo_groups" {
  default = "nubis_global_admins"
}

variable "nubis_user_groups" {
  default = ""
}

variable "root_storage_size" {
  default = "0"
}

variable "public" {
  default = false
}
