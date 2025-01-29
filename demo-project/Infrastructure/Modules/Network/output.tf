# APP VNET
output "app_vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "app_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "aks_app_subnet_id" {
  value = azurerm_subnet.snet-aks.id
}