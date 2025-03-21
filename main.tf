provider "azurerm" {
  features {}
  use_oidc = true
}

module "rg1" {
  source = "./module/azure/rg"

  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source = "./module/azure/acr"

  name     = var.acr_name
  sku      = var.acr_sku
  rg_name  = module.rg1.name
  location = var.location

  depends_on = [module.rg1]
}

module "aca" {
  source = "./module/azure/aca"

  name             = "gmezanappcontainerzzz"
  rg_name          = module.rg1.name
  location         = var.location
  external_enabled = true

  depends_on = [module.rg1]
}