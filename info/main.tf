provider "aws" {
  region = "${var.region}"

  allowed_account_ids = [
    "${terraform_remote_state.info.output.account_id}",
  ]
}

resource "terraform_remote_state" "info" {
  backend = "http"

  config {
    address = "http://state.nubis.nubis-lab.nubis.allizom.org/aws/${var.region}/${var.environment}.tfstate"
  }
}

resource "aws_security_group" "dummy" {}
