module "components" {
  source            = "https://github.com/naveen3607/vpc-module-terraform.git"

  for_each          = var.vpc
  cidr = each.value[cidr]
}