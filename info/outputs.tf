output "account_id" {
  value = "${element(concat(data.terraform_remote_state.info.*.account_id, list("")), 0)}"
}

output "arena" {
  value = "${element(concat(data.terraform_remote_state.info.*.arena, list("")), 0)}"
}

output "availability_zones" {
  value = "${element(concat(data.terraform_remote_state.info.*.availability_zones, list("")), 0)}"
}

output "hosted_zone_id" {
  value = "${element(concat(data.terraform_remote_state.info.*.hosted_zone_id, list("")), 0)}"
}

output "hosted_zone_name" {
  value = "${element(concat(data.terraform_remote_state.info.*.hosted_zone_name, list("")), 0)}"
}

output "nubis_version" {
  value = "${element(concat(data.terraform_remote_state.info.*.nubis_version, list("")), 0)}"
}

output "private_subnets" {
  value = "${element(concat(data.terraform_remote_state.info.*.private_subnets, list("")), 0)}"
}

output "public_subnets" {
  value = "${element(concat(data.terraform_remote_state.info.*.public_subnets, list("")), 0)}"
}

output "vpc_id" {
  value = "${element(concat(data.terraform_remote_state.info.*.vpc_id, list("")), 0)}"
}

output "monitoring_security_group" {
  value = "${element(concat(data.terraform_remote_state.info.*.monitoring_security_group, list("")), 0)}"
}

output "ssh_security_group" {
  value = "${element(concat(data.terraform_remote_state.info.*.ssh_security_group, list("")), 0)}"
}

output "internet_access_security_group" {
  value = "${element(concat(data.terraform_remote_state.info.*.internet_access_security_group, list("")), 0)}"
}

output "shared_services_security_group" {
  value = "${element(concat(data.terraform_remote_state.info.*.shared_services_security_group, list("")), 0)}"
}

output "sso_security_group" {
  value = "${element(concat(data.terraform_remote_state.info.*.sso_security_group, list("")), 0)}"
}

output "instance_security_groups" {
  value = "${element(concat(data.terraform_remote_state.info.*.instance_security_groups, list("")), 0)}"
}

output "rds_mysql_parameter_group" {
  value = "${element(concat(data.terraform_remote_state.info.*.rds_mysql_parameter_group, list("")), 0)}"
}

output "access_logging_bucket" {
  value = "${element(concat(data.terraform_remote_state.info.*.access_logging_bucket, list("")), 0)}"
}

output "network_cidr" {
  value = "${element(concat(data.terraform_remote_state.info.*.network_cidr, list("")), 0)}"
}

output "private_network_cidr" {
  value = "${element(concat(data.terraform_remote_state.info.*.private_network_cidr, list("")), 0)}"
}

output "public_network_cidr" {
  value = "${element(concat(data.terraform_remote_state.info.*.public_network_cidr, list("")), 0)}"
}

output "nubis_domain" {
  value = "${element(concat(data.terraform_remote_state.info.*.nubis_domain, list("")), 0)}"
}

output "master_zone_id" {
  value = "${element(concat(data.terraform_remote_state.info.*.master_zone_id, list("")), 0)}"
}
