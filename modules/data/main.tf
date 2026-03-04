resource "azurerm_resource_group" "rg_data" {
  name     = "${var.prefix}-data-rg"
  location = var.location
}


resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.prefix}-sqlserver"
  resource_group_name          =  azurerm_resource_group.rg_data.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.admin_password
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "db" {
  name      = "retailcorp-db"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic" 
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
}