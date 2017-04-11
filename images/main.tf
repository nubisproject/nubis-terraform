provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name = "name"

    values = [
      "${var.project} ${var.version} ${var.storage} ${var.os}",
    ]
  }

  owners = ["${var.owner}"]
}
