output "account_id" {
  value = "${data.terraform_remote_state.info.account_id}"
}

output "arena" {
  value = "${data.terraform_remote_state.info.arena}"
}

output "availability_zones" {
  value = "${data.terraform_remote_state.info.availability_zones}"
}

output "hosted_zone_id" {
  value = "${data.terraform_remote_state.info.hosted_zone_id}"
}

output "hosted_zone_name" {
  value = "${data.terraform_remote_state.info.hosted_zone_name}"
}

output "nubis_version" {
  value = "${data.terraform_remote_state.info.nubis_version}"
}

output "private_subnets" {
  value = "${data.terraform_remote_state.info.private_subnets}"
}

output "public_subnets" {
  value = "${data.terraform_remote_state.info.public_subnets}"
}

output "vpc_id" {
  value = "${data.terraform_remote_state.info.vpc_id}"
}

output "monitoring_security_group" {
  value = "${data.terraform_remote_state.info.monitoring_security_group}"
}

output "ssh_security_group" {
  value = "${data.terraform_remote_state.info.ssh_security_group}"
}

output "internet_access_security_group" {
  value = "${data.terraform_remote_state.info.internet_access_security_group}"
}

output "shared_services_security_group" {
  value = "${data.terraform_remote_state.info.shared_services_security_group}"
}

output "sso_security_group" {
  value = "${data.terraform_remote_state.info.sso_security_group}"
}

output "instance_security_groups" {
  value = "${data.terraform_remote_state.info.instance_security_groups}"
}

output "rds_mysql_parameter_group" {
  value = "${data.terraform_remote_state.info.rds_mysql_parameter_group}"
}

output "access_logging_bucket" {
  value = "${data.terraform_remote_state.info.access_logging_bucket}"
}
