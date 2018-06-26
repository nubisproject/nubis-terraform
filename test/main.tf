module "worker" {
  source        = "../worker"
  account       = "nubis-gozer"
  region        = "us-west-2"
  environment   = "stage"
  service_name  = "gozer-test"
  purpose       = "test"
  ami           = "ami-eff28d97"
  swap_size_meg = "1024"
}

module "database" {
  source                 = "../database"
  region                 = "us-west-2"
  environment            = "stage"
  account                = "nubis-gozer"
  monitoring             = false
  service_name           = "testdb"
  client_security_groups = "${module.worker.security_group}"
  name                   = "testdb"
  engine                 = "postgres"
  engine_version         = "9.5"
  username               = "gozer"
  monitoring             = true
  multi_az               = true
  replica_count          = 0
}
