output "aks_app_node_resource_group" {
  value = azurerm_kubernetes_cluster.aks_app.node_resource_group
}
output "aks_app_id" {
  value = azurerm_kubernetes_cluster.aks_app.id
}
output "aks_app_kube_config_raw" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config_raw
}
output "aks_app_egress_ip" {
  value = azurerm_public_ip.aks_egress_ip.ip_address
}
output "aks_app_kubelet_identity_id" {
  value = azurerm_kubernetes_cluster.aks_app.kubelet_identity[0].object_id
}
output "aks_app_dns_prefix_private_cluster" {
  value = azurerm_kubernetes_cluster.aks_app.dns_prefix_private_cluster
}