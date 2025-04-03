resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

module "resource_group" {
  source = "./module/azure/rg"

  name     = random_pet.rg_name.id
  location = var.location
}

module "azure_congnitive_account" {
  source = "./module/azure/aoai"

  name     = "azurecognitive01"
  rg_name  = module.resource_group.name
  location = var.location

  depends_on = [module.resource_group]
}

module "azure_openai_deployment" {
  source = "./module/azure/aoai_deployment"

  name    = "gmezanopenai01"
  rg_name = module.resource_group.name
}