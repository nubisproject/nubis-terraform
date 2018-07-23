variable "enabled" {
  description = "Flag to enable or disable resource creation (Valid options are 1 or 0)"
  default     = "1"
}

variable "account" {}

variable "region" {}

variable "environment" {}

variable "service_name" {}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "purpose" {}

variable "role" {}

# Must be correctly set, hard-coded, when using multiple roles
variable "role_cnt" {
  default = 1
}

variable "website_index" {
  default = "index.html"
}

variable "acl" {
  default = "private"
}

variable "arena" {
  default = "core"
}

variable "storage_encrypted_at_rest" {
  default = false
}

variable "expiration_days" {
  default = "0"
}

variable "transitions" {
  type = "map"

  default = {
    STANDARD_IA = 0
    ONEZONE_IA  = 0
    GLACIER     = 0
  }
}
