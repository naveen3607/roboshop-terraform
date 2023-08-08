module "components" {
  source            = "git::https://github.com/naveen3607/tf-module-basic-test.git"
  for_each          = var.components
  instance_type     = var.instance_type
  name              = each.value["name"]
  zone_id           = var.zone_id
  security_group    = var.security_group
}