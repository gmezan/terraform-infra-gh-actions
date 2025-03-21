module "rg" {
  source = "./module/azure/rg"

  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source = "./module/azure/acr"

  name     = var.acr_name
  sku      = var.acr_sku
  rg_name  = module.rg.name
  location = var.location

  depends_on = [module.rg]
}