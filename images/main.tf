provider "aws" {
  version = "~> 0.1"
  region  = "${var.region}"
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
      "${var.project} ${var.image_version} ${var.storage} ${var.os}",
    ]
  }

  owners = ["${var.owner}"]
}
