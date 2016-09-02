output "account_id" {
  value = "${terraform_remote_state.info.output.account_id}"
}

output "availability_zones" {
  value = "${terraform_remote_state.info.output.availability_zones}"
}

output "hosted_zone_id" {
  value = "${terraform_remote_state.info.output.hosted_zone_id}"
}

output "hosted_zone_name" {
  value = "${terraform_remote_state.info.output.hosted_zone_name}"
}

output "nubis_version" {
  value = "${terraform_remote_state.info.output.nubis_version}"
}

output "private_subnets" {
  value = "${terraform_remote_state.info.output.private_subnets}"
}

output "public_subnets" {
  value = "${terraform_remote_state.info.output.public_subnets}"
}

output "vpc_id" {
  value = "${terraform_remote_state.info.output.vpc_id}"
}

output "monitoring_security_group" {
  value = "${terraform_remote_state.info.output.monitoring_security_group}"
}

output "ssh_security_group" {
  value = "${terraform_remote_state.info.output.ssh_security_group}"
}

output "internet_access_security_group" {
  value = "${terraform_remote_state.info.output.internet_access_security_group}"
}

output "shared_services_security_group" {
  value = "${terraform_remote_state.info.output.shared_services_security_group}"
}

output "instance_security_groups" {
  value = "${terraform_remote_state.info.output.instance_security_groups}"
}

output "rds_mysql_parameter_group" {
  value = "${terraform_remote_state.info.output.rds_mysql_parameter_group}"
}
