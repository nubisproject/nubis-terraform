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
    name   = "cache_port"
    path   = "${module.consul.config_prefix}/Cache/Port"
    value  = "${element(split(":",aws_elasticache_cluster.cache.configuration_endpoint), 1)}"
    delete = true
  }

  key {
    name   = "cache_endpoint"
    path   = "${module.consul.config_prefix}/Cache/Endpoint"
    value  = "${element(split(":",aws_elasticache_cluster.cache.configuration_endpoint), 0)}"
    delete = true
  }
}
