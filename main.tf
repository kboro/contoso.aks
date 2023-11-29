# Define local variables
locals {
  vnet_address_space  = "10.1.0.0/16"
  backend_subnet_cidr = "10.1.0.0/24"
  db_subnet_cidr      = "10.1.1.0/24"
  appgw_subnet_cidr   = "10.1.2.0/24"
}

# Retrieve Azure client configuration
data "azurerm_client_config" "current" {}

# Create Azure resource group for AKS
resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-rg"
  location = "westeurope"
}

# Provision network resources using the network module
module "network" {
  depends_on                      = [azurerm_resource_group.aks_rg]
  source                          = "./modules/network"
  resource_group_name             = azurerm_resource_group.aks_rg.name
  appgw_subnet_address_prefixes   = local.appgw_subnet_cidr
  backend_subnet_address_prefixes = local.backend_subnet_cidr
  db_subnet_address_prefixes      = local.db_subnet_cidr
  vnet_address_space              = local.vnet_address_space
}

# Provision AKS cluster using the AKS module
module "aks" {
  depends_on                = [azurerm_resource_group.aks_rg]
  source                    = "./modules/aks"
  aks_name                  = "aks-cluster"
  resource_group_name       = azurerm_resource_group.aks_rg.name
  default_node_pool_vm_size = "Standard_DS2_v2"
  backend_subnet_id         = module.network.backend_subnet_id
  appgw_subnet_id           = module.network.appgw_subnet_id
}

# Provision database resources using the database module
module "database" {
  depends_on          = [azurerm_resource_group.aks_rg]
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.aks_rg.name
  db_subnet_id        = module.network.db_subnet_id
  server_name         = "kboro-server"
  db_name             = "test-db"
}