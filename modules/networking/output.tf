output "subnet_id" {
  value = azurerm_subnet.web_subnet.id
}

output "network_rg_name" {
  value = azurerm_resource_group.network_rg.name
}

output "db_subnet_id" {
  value = azurerm_subnet.pe_snet.id
}