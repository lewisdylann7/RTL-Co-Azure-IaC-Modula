resource "azurerm_resource_group" "network_rg" {
    name = "${var.prefix}-net-rg"
    location = var.location
  
}

resource "azurerm_virtual_network" "main" {
  name = "retail-vnet"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = azurerm_resource_group.network_rg.name
}

resource "azurerm_subnet" "web_subnet" {
  name = "web_subnet"
  resource_group_name = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.1.0/24"] 
}

resource "azurerm_subnet" "db_subnet" {
  name = "db_subnet"
  resource_group_name = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes =  ["10.0.2.0/24"] 
}


resource "azurerm_subnet" "pe_snet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/24"]
  
  private_endpoint_network_policies = "Enabled"
}