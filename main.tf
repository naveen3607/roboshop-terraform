module "vpc" {
  source            = "git::https://github.com/naveen3607/vpc-module-terraform.git"
  for_each          = var.vpc
  cidr = each.value["cidr"]
  subnets = each.value["subnets"]
  default_vpc_id = var.default_vpc_id
}

output "vpc" {
  value = module.vpc
}