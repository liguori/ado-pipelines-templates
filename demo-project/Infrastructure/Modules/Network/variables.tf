variable "location" {
  type        = string
}
variable "resource_group_name" {
  type        = string
}
variable "resource_unique_identifier" {
  type        = string
}
variable "environment" {
  type        = string
}
variable "progressive_Id" {
  type        = string
}
variable "address_space" {
  type        = string
}
variable "aks_subnet_prefix" {
  type        = string
}
variable "privatelink_subnet_prefix" {
  type        = string
}
variable "tags" {
  type        = map(string)
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
  vnet_name = "vnt-${var.resource_unique_identifier}-${local.env_map[var.environment]}-${local.location_map[lower(var.location)]}-${var.progressive_Id}"

}
