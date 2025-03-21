resource "azurerm_container_app_environment" "environment" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_container_app" "container_app" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}