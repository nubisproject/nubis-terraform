output "endpoint" {
  value = "${aws_elasticache_cluster.cache.configuration_endpoint}"
}

output "endpoint_host" {
  value = "${element(split(":",aws_elasticache_cluster.cache.configuration_endpoint), 0)}"
}

output "endpoint_port" {
  value = "${element(split(":",aws_elasticache_cluster.cache.configuration_endpoint), 1)}"
}
