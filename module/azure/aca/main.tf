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

  ingress {
    external_enabled = var.external_enabled
    exposed_port     = 80
    target_port      = 80
    traffic_weight {
      percentage = 1
    }
  }

  template {
    container {
      name   = "examplecontainerapp2"
      image  = "nginx"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}