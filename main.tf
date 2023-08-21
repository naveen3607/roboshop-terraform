module "vpc" {
  source            = "git::https://github.com/naveen3607/vpc-module-terraform.git"
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
  source            = "git::https://github.com/naveen3607/load-balancer-module-terraform.git"
  for_each          = var.alb
  lb_type = each.value["lb_type"]
  tags = var.tags
  env = var.env
}


output "vpc" {
  value = module.vpc
}