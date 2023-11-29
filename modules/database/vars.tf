variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the database will be created."
}

variable "db_subnet_id" {
  type        = string
  description = "The ID of the subnet where the database server will be deployed."
}

variable "server_name" {
  type        = string
  description = "The name of the database server."
}

variable "db_name" {
  type        = string
  description = "The name of the database."
}