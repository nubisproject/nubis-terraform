provider "aws" {
  region = "${var.region}"
}

resource "terraform_remote_state" "info" {
  backend = "http"

  config {
    address = "http://state.nubis.${var.account}.nubis.allizom.org/aws/${var.region}/${var.environment}.tfstate"
  }
}
