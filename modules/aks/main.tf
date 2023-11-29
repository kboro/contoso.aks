# Create an Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_name
  location            = "westeurope"
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-cluster"

  # Define the default node pool for the AKS cluster
  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = var.default_node_pool_vm_size
    vnet_subnet_id = var.backend_subnet_id
  }

  # Configure the network profile for the AKS cluster
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  # Configure the Application Gateway for ingress traffic
  ingress_application_gateway {
    gateway_name = "aks-cluster-agic"
    subnet_id    = var.appgw_subnet_id
  }

  # Enable system-assigned managed identity for the AKS cluster
  identity {
    type = "SystemAssigned"
  }
}

# Assign the Network Contributor role to the AKS cluster's Application Gateway identity
resource "azurerm_role_assignment" "gateway_identity" {
  scope                = var.appgw_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}