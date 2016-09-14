output "password" {
  value = "${aws_db_instance.database.password}"
}
output "username" {
  value = "${aws_db_instance.database.username}"
}

output "address" {
  value = "${aws_db_instance.database.address}"
}

output "name" {
  value = "${aws_db_instance.database.name}"
}

output "replicas" {
  value = "${join(",",aws_db_instance.replica.*.address)}"
}
