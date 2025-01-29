variable "subscription_id" {}
variable "location" {}
variable "resource_group" {}

variable "resource_unique_identifier" {
  default = "demoaksgiliguor"
}
variable "rg_suffix" {
  default = ""
}

variable "progressive_Id" {
  type        = string
}


variable "environment" {}

# Aks
variable "private_cluster" {
  default = false
}
variable "kubernetes_version" {
  default = "1.30.7"
}
variable "kubernetes_add_userpool" {
  type    = bool
  default = true
}
variable "aks_app_dns_ip" {}
variable "aks_app_service_cidr" {}
variable "aks_app_node_count" {
  type    = number
  default = 1
}
variable "aks_system_vm_size" {
  default = "Standard_DC2ds_v3"
}
variable "aks_app_disk_size" {
  default = 128
}
variable "aks_sku_tier" {
  default = "Free"
}
variable "aks_app_vnet_name" {
  default = null
}
variable "aks_app_subnet_name" {
  default = "snet-aks"
}

variable "address_space" {}
variable "privatelink_subnet_prefix" {}
variable "aks_subnet_prefix" {}

variable "aks_add_user_pool" {
  type        = bool
}
variable "aks_user_pool_vm_size" {
  type        = string
}

variable "aks_user_pool_node_count" {
  type        = number
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
  tags_rg = {
    "ProjectName" = "DemoAKS"
    "ProjectID"   = "ABC124"
  }
  tags_resources = {
    "ProjectName" = "DemoAKS"
    "ProjectID"   = "ABC124"
  }
}
