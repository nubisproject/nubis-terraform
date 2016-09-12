output "security_group" {
  # The join() is important here, just to turn *.id into a string for coalesce
  value = "${coalesce(join(",", aws_security_group.extra.*.id), var.security_group)}"
}

output "instance_profile" {
  value = "${coalesce(join(",", aws_iam_instance_profile.extra.*.name), var.instance_profile)}"
}

output "role" {
  value = "${coalesce(join(",", aws_iam_role.extra.*.name), var.role)}"
}

output "autoscaling_group" {
  value = "${aws_autoscaling_group.asg.id}"
}
