subscription_id = "your_subscription_id"
location        = "westeurope"
environment     = "development"

resource_group = "rg-devops-demo"

progressive_Id = "100"

resource_unique_identifier = "demoaksiac"

address_space             = "10.0.0.0/9"
privatelink_subnet_prefix = "10.0.0.0/24"
aks_subnet_prefix         = "10.1.0.0/16"

aks_app_service_cidr = "10.128.0.0/16"
aks_app_dns_ip       = "10.128.0.10"

kubernetes_version       = "1.30.7"
aks_user_pool_vm_size    = "Standard_DC2ds_v3"
aks_add_user_pool        = true
aks_user_pool_node_count = 3