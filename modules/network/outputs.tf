output "backend_subnet_id" {
  value = azurerm_subnet.backend_subnet.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}