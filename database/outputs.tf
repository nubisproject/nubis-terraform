output "password" {
  value = "${aws_db_instance.database.password}"
}

output "address" {
  value = "${aws_db_instance.database.address}"
}

output "replicas" {
  value = "${join(",",aws_db_instance.replica.*.address)}"
}
