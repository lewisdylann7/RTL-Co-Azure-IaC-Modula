data "azurerm_client_config" "current" {
  
}

resource "azurerm_resource_group" "rg_data" {
  name     = "${var.prefix}-data-rg"
  location = var.location
  tags = {
    Environment = "Production"
    Project     = "Retail-Migration"
    ManagedBy   = "Terraform"
  }
}


resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg_data.name
}


resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "sql-vnet-link"
  resource_group_name   = azurerm_resource_group.rg_data.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  virtual_network_id    = var.vnet_id
}



resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.prefix}-sqlserver"
  resource_group_name          =  azurerm_resource_group.rg_data.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.admin_password
  public_network_access_enabled = false
  tags = azurerm_resource_group.rg_data.tags
}

resource "azurerm_mssql_database" "db" {
  name      = "retailcorp-db"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic" 
  tags = azurerm_resource_group.rg_data.tags
}


resource "azurerm_private_endpoint" "sql_pe" {
  name                = "pe-sql-database"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_data.name
  subnet_id           = var.db_subnet_id

  private_service_connection {
    name                           = "sql-privatelink"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns.id]
  }

  tags = azurerm_resource_group.rg_data.tags
}




resource "azurerm_role_assignment" "sql_rbac" {
  scope                = azurerm_mssql_server.sql_server.id
  role_definition_name = "SQL Server Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}