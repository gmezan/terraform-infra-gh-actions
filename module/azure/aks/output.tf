output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "cluster" {
  value = {
    cluster      = azurerm_kubernetes_cluster.k8s
    principal_id = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
  }
}