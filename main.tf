resource "random_pet" "rg_name" {
  prefix = "rg"
}

module "resource_group" {
  source = "./module/azure/rg"

  name     = random_pet.rg_name.id
  location = var.location
}

resource "random_pet" "aoai" {
  prefix    = "gmcoac"
  separator = ""
}

module "azure_cognitive_account" {
  source = "./module/azure/aoai"

  name     = random_pet.aoai.id
  rg_name  = module.resource_group.name
  location = var.location

  depends_on = [module.resource_group]
}

module "azure_openai_deployment" {
  source = "./module/azure/aoai_deployment"

  cognitive_account_id = module.azure_cognitive_account.id
  name                 = "gpt-4o-mini"
  model_name           = "gpt-4o-mini"
  rg_name              = module.resource_group.name
  capacity             = 8

  depends_on = [module.resource_group, module.azure_cognitive_account]
}

resource "random_pet" "search" {
  prefix    = "gmaise"
  separator = ""
}

module "azurerm_search_service" {
  source = "./module/azure/search"

  name     = random_pet.search.id
  rg_name  = module.resource_group.name
  location = var.location

  depends_on = [module.resource_group]
}