# Generate random cluster name
resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location                          = var.location
  name                              = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name               = var.rg_name
  dns_prefix                        = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  role_based_access_control_enabled = var.rbac_enabled
  oidc_issuer_enabled               = var.oidc_issuer_enabled
  workload_identity_enabled         = var.workload_identity_enabled
  sku_tier                          = var.sku

  storage_profile {
    disk_driver_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                 = "agentpool"
    vm_size              = "Standard_D2_v2"
    node_count           = var.node_count
    ultra_ssd_enabled    = false
    auto_scaling_enabled = var.auto_scaling
    min_count            = var.auto_scaling ? var.node_min_count : null
    max_count            = var.auto_scaling ? var.node_max_count : null
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}