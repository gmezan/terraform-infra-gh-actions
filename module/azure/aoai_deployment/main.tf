resource "azurerm_cognitive_deployment" "aoai_deployment" {
  name                 = var.name
  cognitive_account_id = var.cognitive_account_id

  model {
    format  = var.format
    name    = var.deployment_name
    version = var.model_version
  }

  sku {
    name = var.sku_name
    tier = var.sku_tier
  }
}