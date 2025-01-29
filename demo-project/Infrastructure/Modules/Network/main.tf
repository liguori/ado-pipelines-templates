resource "azurerm_virtual_network" "vnet" {
  address_space = [
    var.address_space
  ]
  location            = var.location
  name                = local.vnet_name
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "snet-aks" {
  name                                           = "snet-aks"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name

  address_prefixes = [
    var.aks_subnet_prefix
  ]
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Sql",
    "Microsoft.Web"
  ]
}