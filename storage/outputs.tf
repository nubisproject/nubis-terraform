output "fsid" {
  value = "${aws_efs_file_system.storage.id}"
}

output "security_group" {
  value = "${aws_security_group.storage.id}"
}
