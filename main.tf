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

  name          = var.acr_name
  sku           = var.acr_sku
  rg_name       = module.rg1.name
  location      = var.location
  admin_enabled = true

  depends_on = [module.rg1]
}

module "aks" {
  source = "./module/azure/aks"

  rg_name                   = module.rg1.name
  location                  = var.location
  rbac_enabled              = true
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  node_count                = 1

  depends_on = [module.rg1]
}