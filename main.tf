resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

module "resource_group" {
  source = "./module/azure/rg"

  name     = random_pet.rg_name.id
  location = var.location
}

module "azure_cognitive_account" {
  source = "./module/azure/aoai"

  name     = "azurecognitivegmezan01"
  rg_name  = module.resource_group.name
  location = var.location

  depends_on = [module.resource_group]
}

module "azure_openai_deployment" {
  source               = "./module/azure/aoai_deployment"
  cognitive_account_id = module.azure_cognitive_account.id

  name     = "gmezanopenai02"
  rg_name  = module.resource_group.name
  capacity = 1000

  depends_on = [module.resource_group, module.azure_cognitive_account]
}