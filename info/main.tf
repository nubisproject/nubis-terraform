provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "info" {
  backend = "http"

  config {
    address = "http://state.nubis.${var.account}.${var.nubis_domain}/aws/${var.region}/${var.arena}.tfstate"
  }
}
