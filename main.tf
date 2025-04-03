resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

module "resource_group" {

  source = "./module/azure/rg"

  name     = random_pet.rg_name.id
  location = var.location
}