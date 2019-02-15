output "endpoint" {
  value = "${var.engine == "memcached" ? element(concat(aws_elasticache_cluster.memcache.*.configuration_endpoint, list("")), 0) : "" }"
}

output "nodes" {
  value = "${aws_elasticache_cluster.redis.*.cache_nodes}"
}

output "endpoint_host" {
  value = "${ var.engine == "memcached" ? element(split(":", join("", aws_elasticache_cluster.memcache.*.configuration_endpoint)), 0) : "" }"
}

output "endpoint_port" {
  value = "${var.engine == "memcached" ? "11211" : "6379"}"
}
