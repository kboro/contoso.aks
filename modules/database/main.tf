# Generate a random password for the SQL server
resource "random_password" "sql_password" {
  length  = 12
  special = true
}

# Create an Azure SQL server
resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = "westeurope"
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = random_password.sql_password.result
}

# Create an Azure SQL database
resource "azurerm_mssql_database" "test" {
  name           = var.db_name
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
}

# Create a virtual network rule for the SQL server
resource "azurerm_mssql_virtual_network_rule" "sqlvnet" {
  name      = "sql-vnet-integration"
  server_id = azurerm_mssql_server.mssql_server.id
  subnet_id = var.db_subnet_id
}

# Retrieve the Azure Key Vault
data "azurerm_key_vault" "kv" {
  name                = "kboro-kv-aks"
  resource_group_name = "misc"
}

# Store the SQL password in Azure Key Vault
resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sqladmin-password"
  value        = random_password.sql_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}