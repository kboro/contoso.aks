# Create a virtual network for the spoke
resource "azurerm_virtual_network" "vnet_spoke" {
  name                = "vnet-spoke"
  address_space       = ["${var.vnet_address_space}"]
  location            = "westeurope"
  resource_group_name = var.resource_group_name
}

# Create a subnet for the backend services
resource "azurerm_subnet" "backend_subnet" {
  name                 = "backend_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke.name
  address_prefixes     = ["${var.backend_subnet_address_prefixes}"]
}

# Create a subnet for the database services
resource "azurerm_subnet" "db_subnet" {
  name                 = "db_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke.name
  address_prefixes     = ["${var.db_subnet_address_prefixes}"]
  service_endpoints    = ["Microsoft.Sql"]
}

# Create a subnet for the application gateway
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke.name
  address_prefixes     = ["${var.appgw_subnet_address_prefixes}"]
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = "westeurope"
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-aks-to-db"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = azurerm_subnet.backend_subnet.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]
  }
}

resource "azurerm_subnet_network_security_group_association" "db_nsg" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

# Create a network security group for the backend subnet
resource "azurerm_network_security_group" "backend_nsg" {
  name                = "backend-nsg"
  location            = "westeurope"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "backend_nsg" {
  subnet_id                 = azurerm_subnet.backend_subnet.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}