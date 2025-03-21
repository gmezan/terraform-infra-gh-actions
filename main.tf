module "rg1" {
  source = "./module/azure/rg"

  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source = "./module/azure/acr"

  name = "gmezanregistry001"
  sku  = "Basic"
  rg   = rg1
}