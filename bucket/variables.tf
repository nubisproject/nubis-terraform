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
