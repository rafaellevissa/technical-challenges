module "network" {
  source   = "./modules/network"
  domain_name = var.domain_name
  vpc_cidr = "10.0.0.0/16"
}

module "frontend" {
  source      = "./modules/frontend"
  domain_name = "app.${module.network.hosted_zone_name}"
  zone_id     = module.network.hosted_zone_id
}

module "auth" {
  source = "./modules/auth"
}

module "database" {
  source             = "./modules/database"
  vpc_id             = module.network.vpc_id
  private_subnets    = module.network.private_subnets
  allowed_cidr_block = module.network.vpc_cidr
  db_password        = var.db_password
}

module "compute" {
  source          = "./modules/compute"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
}

module "worker" {
  source          = "./modules/worker"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  ecr_repository_url = module.compute.ecr_url
}
