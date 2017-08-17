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
    path   = "${module.consul.config_prefix}/MemCachedPort"
    value  = "${module.cache.endpoint_port}"
    delete = true
  }

  key {
    name   = "cache_endpoint"
    path   = "${module.consul.config_prefix}/MemCachedEndpoint"
    value  = "${module.cache.endpoint_host}"
    delete = true
  }
}
