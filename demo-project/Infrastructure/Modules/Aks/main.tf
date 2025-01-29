data "azurerm_resource_group" "rg_aks" {
  name = var.resource_group_name
}


data "azurerm_virtual_network" "app_vnet" {
  name                = var.app_vnet_name
  resource_group_name = var.network_rg
}

data "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet_name
  resource_group_name  = var.network_rg
  virtual_network_name = var.app_vnet_name
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = local.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
}


data "azurerm_client_config" "context" {}

resource "azurerm_public_ip" "aks_egress_ip" {
  allocation_method   = "Static"
  sku                 = "Standard"
  location            = var.location
  name                = "${local.aks_name}-pip-egress"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "aks_uai" {
  location            = var.location
  name                = "uai-${local.aks_name}"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "aks_zone" {
  count               = var.private_cluster_enabled == true ? 1 : 0
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.network_rg
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "aks_app" {

  dns_prefix_private_cluster = (var.private_cluster_enabled) ? "${local.aks_name}" : null
  dns_prefix                 = (var.private_cluster_enabled) ? null : "${local.aks_name}"
  location                   = var.location
  name                       = local.aks_name
  node_resource_group        = "rg-${local.aks_name}"
  resource_group_name        = var.resource_group_name
  sku_tier                   = var.aks_sku_tier
  private_cluster_enabled    = var.private_cluster_enabled
  private_dns_zone_id        = (var.private_cluster_enabled) ? azurerm_private_dns_zone.aks_zone[0].id : null

  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    managed                = true
    tenant_id              = data.azurerm_client_config.context.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = var.aks_app_service_cidr
    dns_service_ip = var.aks_app_dns_ip
    network_policy = var.aks_network_policy

    load_balancer_profile {
      outbound_ip_address_ids = [
        azurerm_public_ip.aks_egress_ip.id
      ]
    }
  }
  default_node_pool {
    name                = "systempool"
    vm_size             = var.aks_system_vm_size
    node_count          = local.node_count_per_pool
    os_disk_size_gb     = var.disk_size
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = data.azurerm_subnet.app_subnet.id
    enable_auto_scaling = false
    tags                = var.tags
  }
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_uai.id
    ]
  }
  kubernetes_version = var.kubernetes_version

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  tags = merge(var.tags)

  lifecycle {
    ignore_changes = [
      api_server_authorized_ip_ranges
    ]
  }
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "aks_csi_access_policy" {
  key_vault_id = data.azurerm_key_vault.kv.id
  object_id    = azurerm_kubernetes_cluster.aks_app.key_vault_secrets_provider[0].secret_identity[0].object_id
  tenant_id    = data.azurerm_client_config.context.tenant_id
  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_pool_user" {
  count = var.aks_add_user_pool ? 1 : 0

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_app.id
  name                  = "apppool"
  vm_size               = var.aks_user_pool_vm_size
  node_count            = var.aks_user_pool_node_count
  orchestrator_version  = var.kubernetes_version
  tags                  = merge(var.tags)
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks_app.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_vnet_contributor" {
  principal_id                     = azurerm_user_assigned_identity.aks_uai.principal_id
  role_definition_name             = "Network Contributor"
  scope                            = data.azurerm_resource_group.rg_aks.id
  skip_service_principal_aad_check = true
}