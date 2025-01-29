variable "location" {
  type        = string
}
variable "resource_group_name" {
  type        = string
}
variable "resource_unique_identifier" {
  type        = string
  default     = "demo"
}
variable "environment" {
  type        = string
}
variable "progressive_Id" {
  type        = string
}
variable "aks_system_vm_size" {
  type        = string
}
variable "private_cluster_enabled" {
  type        = bool
  default     = true
}
variable "app_node_count" {
  type        = number
}

variable "app_vnet_name" {
  type        = string
}


variable "app_subnet_name" {
  type        = string
}

variable "network_rg" {
  type        = string
}

variable "disk_size" {
  type        = number
}
variable "kubernetes_version" {
  type        = string
}
variable "aks_app_service_cidr" {
  type        = string
}

variable "aks_app_dns_ip" {
  type        = string
}

variable "acr_id" {
  type    = string
}

variable "aks_network_policy" {
  type    = string
  default = "calico"
}
variable "aks_sku_tier" {
  default = null
}
variable "key_vault_name" {}
variable "key_vault_resource_group" {}
variable "aks_add_user_pool" {
  type        = bool
  default     = true
}
variable "aks_user_pool_vm_size" {
  type        = string
}
variable "aks_user_pool_node_count" {
  type        = number
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "Lista di grouppi AAD con privilegi di admin su AKS."
}
variable "tags" {
  type        = map(string)
  description = "Tag da associare alle risorse di questo modulo."
}

locals {
  env_map = {
    development = "dev"
    staging     = "stg"
    production  = "prod"
  }
  location_map = {
    westeurope  = "we"
    northeurope = "ne"
  }
  log_analytics_workspace_name = "law-${var.resource_unique_identifier}-${local.env_map[var.environment]}-${local.location_map[lower(var.location)]}-${var.progressive_Id}"
  aks_name                     = "aks-${var.resource_unique_identifier}-${local.env_map[var.environment]}-${local.location_map[lower(var.location)]}-${var.progressive_Id}"
  ppg_name                     = "ppg-${var.resource_unique_identifier}-${local.env_map[var.environment]}-${local.location_map[lower(var.location)]}-${var.progressive_Id}"
  pool_count                   = floor(var.app_node_count / 100)
  node_count_per_pool          = ceil(var.app_node_count / (local.pool_count + 1))
}
