output "image_id" {
  value = "${data.aws_ami.image.image_id}"
}

output "name" {
  value = "${data.aws_ami.image.name}"
}
