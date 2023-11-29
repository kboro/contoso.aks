variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster will be deployed."
}

variable "aks_name" {
  type        = string
  description = "The name of the AKS cluster."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The size of the virtual machines in the default node pool."
}

variable "backend_subnet_id" {
  type        = string
  description = "The ID of the subnet where the backend resources will be deployed."
}

variable "appgw_subnet_id" {
  type        = string
  description = "The ID of the subnet where the application gateway will be deployed."
}