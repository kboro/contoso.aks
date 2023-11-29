variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
}

variable "backend_subnet_address_prefixes" {
  description = "CIDR prefix for backend_subnet"
  type        = string
}

variable "db_subnet_address_prefixes" {
  description = "CIDR prefix for db_subnet"
  type        = string
}

variable "appgw_subnet_address_prefixes" {
  description = "CIDR prefix for appgw_subnet"
  type        = string
}
