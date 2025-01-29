terraform {
  required_providers {
    azurerm = {
      version = "= 3.83.0"
      source  = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-common"
    storage_account_name = "sanamebackend"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  skip_provider_registration = "true"
  features {
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "deploy_rg" {
  name     = var.resource_group
}

resource "azurerm_key_vault" "kv" {
  name                = "kv-${var.resource_unique_identifier}-${local.env_map[var.environment]}"
  location            = var.location
  resource_group_name = var.resource_group
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = local.tags_resources
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.resource_unique_identifier}${local.env_map[var.environment]}"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
  tags                = local.tags_resources
}

module "network" {
  source = "./Modules/Network"

  address_space              = var.address_space
  aks_subnet_prefix          = var.aks_subnet_prefix
  privatelink_subnet_prefix  = var.privatelink_subnet_prefix
  environment                = var.environment
  location                   = var.location
  progressive_Id             = var.progressive_Id
  resource_unique_identifier = var.resource_unique_identifier
  resource_group_name        = var.resource_group
  tags                       = local.tags_resources

}


module "aks" {
  source = "./Modules/Aks"

  progressive_Id                  = var.progressive_Id
  environment                     = var.environment
  kubernetes_version              = var.kubernetes_version
  resource_group_name             = var.resource_group
  aks_app_dns_ip                  = var.aks_app_dns_ip
  aks_app_service_cidr            = var.aks_app_service_cidr
  tags                            = local.tags_resources
  location                        = var.location
  resource_unique_identifier      = var.resource_unique_identifier
  network_rg                      = var.resource_group
  app_node_count                  = var.aks_app_node_count
  disk_size                       = var.aks_app_disk_size
  aks_system_vm_size              = var.aks_system_vm_size
  aks_sku_tier                    = var.aks_sku_tier
  app_subnet_name                 = var.aks_app_subnet_name
  app_vnet_name                   = module.network.app_vnet_name
  private_cluster_enabled         = var.private_cluster
  aks_add_user_pool               = var.kubernetes_add_userpool
  aks_user_pool_vm_size           = var.aks_user_pool_vm_size
  aks_user_pool_node_count        = var.aks_user_pool_node_count
  key_vault_name                  = azurerm_key_vault.kv.name
  key_vault_resource_group        = var.resource_group
  acr_id                          = azurerm_container_registry.acr.id
  depends_on = [
    azurerm_key_vault.kv
  ]
}
