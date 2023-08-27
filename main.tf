module "vpc" {
  source            = "git::https://github.com/naveen3607/tf-module-vpc.git"
  for_each          = var.vpc
  cidr = each.value["cidr"]
  subnets = each.value["subnets"]
  default_vpc_id = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
  tags = var.tags
  env = var.env
}

module "alb" {
  source            = "git::https://github.com/naveen3607/tf-module-alb.git"
  for_each          = var.alb
  internal = each.value["internal"]
  lb_type = each.value["lb_type"]
  sg_ingress_cidr = each.value["sg_ingress_cidr"]
  vpc_id = each.value["internal"] ? local.vpc_id : var.default_vpc_id
  subnets = each.value["internal"] ? local.app_subnets : data.aws_subnets.subnets.ids
  tags = var.tags
  env = var.env
  sg_port = each.value["sg_port"]
}

module "docdb" {
  source            = "git::https://github.com/naveen3607/tf-module-docdb.git"
  for_each          = var.docdb
  subnet_ids = local.db_subnets
  engine_version = each.value["engine_version"]
  engine_family = each.value["engine_family"]
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  sg_ingress_cidr = local.app_subnet_cidr
  vpc_id = local.vpc_id
  tags = var.tags
  env = var.env
  instance_count = each.value["instance_count"]
  instance_class= each.value["instance_class"]
}

module "rds" {
  source            = "git::https://github.com/naveen3607/tf-module-rds.git"
  tags = var.tags
  env = var.env
  for_each          = var.rds
  subnet_ids = local.db_subnets
  engine_version = each.value["engine_version"]
  engine_family = each.value["engine_family"]
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  sg_ingress_cidr = local.app_subnet_cidr
  vpc_id = local.vpc_id
  rds_type = each.value["rds_type"]
  db_port = each.value["db_port"]
  engine = each.value["engine"]
  instance_class = each.value["instance_class"]
  instance_count = each.value["instance_count"]
}

module "elasticache" {
  source            = "git::https://github.com/naveen3607/tf-module-elasticache.git"
  tags = var.tags
  env = var.env
  for_each          = var.elasticache
  subnet_ids = local.db_subnets
  engine_version = each.value["engine_version"]
  family = each.value["family"]
  sg_ingress_cidr = local.app_subnet_cidr
  vpc_id = local.vpc_id
  elasticache_type = each.value["elasticache_type"]
  port = each.value["port"]
  engine = each.value["engine"]
  node_type = each.value["node_type"]
  num_cache_nodes = each.value["num_cache_nodes"]
}

module "rabbitmq" {
  source            = "git::https://github.com/naveen3607/tf-module-rabbitmq.git"
  tags = var.tags
  env = var.env
  for_each          = var.rabbitmq
  subnet_ids = local.db_subnets
  sg_ingress_cidr = local.app_subnet_cidr
  vpc_id = local.vpc_id
  instance_type = each.value["instance_type"]
  ssh_ingress_cidr = var.ssh_ingress_cidr
  zone_id = var.zone_id
}

module "app" {
  source            = "git::https://github.com/naveen3607/tf-module-app.git"
  tags = var.tags
  env = var.env
  for_each          = var.apps
  component = each.key
  port = each.value["port"]
  instance_type = each.value["instance_type"]
  subnet_ids = local.app_subnets
  sg_ingress_cidr = local.app_subnet_cidr
  vpc_id = local.vpc_id
  ssh_ingress_cidr = var.ssh_ingress_cidr
  zone_id = var.zone_id
  desired_capacity = each.value["desired_capacity"]
  max_size = each.value["max_size"]
  min_size = each.value["min_size"]

  alb_name = lookup(lookup(lookup(module.alb, "private", null), "alb", null),"dns_name", null)
  listener = lookup(lookup(lookup(module.alb, "private", null), "listener", null),"arn", null)
}
