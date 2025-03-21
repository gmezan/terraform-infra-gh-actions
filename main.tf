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

resource "azurerm_role_assignment" "aks_to_acr_1" {
  principal_id                     = module.aks.cluster.kubelet_object_id
  role_definition_name             = "AcrPull"
  scope                            = module.acr.id
  skip_service_principal_aad_check = true

  depends_on = [module.aks, module.acr]
}