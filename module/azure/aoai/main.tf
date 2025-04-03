resource "azurerm_cognitive_account" "aoai_account" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.rg_name
  kind                  = var.kind
  custom_subdomain_name = var.name
  sku_name              = var.sku
}