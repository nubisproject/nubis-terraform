# Discover Consul settings
module "consul" {
  source       = "../consul"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# Configure our Consul provider, module can't do it for us
provider "consul" {
  address    = "${module.consul.address}"
  scheme     = "${module.consul.scheme}"
  datacenter = "${module.consul.datacenter}"
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "config" {
  key {
    path   = "${module.consul.config_prefix}/Cache/Engine"
    value  = "${var.engine}"
    delete = true
  }
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "memcache" {
  count = "${var.engine == "memcached" ? 1 : 0}"

  key {
    path   = "${module.consul.config_prefix}/Cache/Port"
    value  = "${element(split(":",aws_elasticache_cluster.memcache.configuration_endpoint), 1)}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Cache/Endpoint"
    value  = "${element(split(":",aws_elasticache_cluster.memcache.configuration_endpoint), 0)}"
    delete = true
  }
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "redis" {
  count = "${var.engine == "redis" ? 1 : 0}"

  key {
    path   = "${module.consul.config_prefix}/Cache/Port"
    value  = "6379"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Cache/Endpoint"
    value  = "${jsonencode(aws_elasticache_cluster.redis.*.cache_nodes)}"
    delete = true
  }
}
