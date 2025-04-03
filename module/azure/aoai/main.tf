resource "azurerm_cognitive_account" "aoai_account" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  kind                = var.kind

  sku_name = var.sku
}