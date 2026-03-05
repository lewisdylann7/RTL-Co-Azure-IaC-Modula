resource "azurerm_resource_group" "rg_sec" {
    name     = "${var.prefix}-security-rg"
    location = var.location
}
data "azurerm_client_config" "current" {
  
}

resource "random_id" "vault_suffix" {
  byte_length = 4
}

resource "azurerm_key_vault" "vault" {
  name = "${var.prefix}-kv-${random_id.vault_suffix.hex}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg_sec.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
  tags = {
    Environment = "Production"
    CostCenter  = "RtlCorp-Retail-01"
    ManagedBy   = "Terraform"
  }
  #access_policy {
   # tenant_id = data.azurerm_client_config.current.tenant_id
    #object_id = data.azurerm_client_config.current.object_id
    #secret_permissions = [ "Get","List","Set","Delete","Purge" ]
  #}
}

resource "azurerm_role_assignment" "kv_role" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}


resource "azurerm_key_vault_secret" "vm_password" {
  name = "vm-admin-password"
  value = var.admin_password
  key_vault_id = azurerm_key_vault.vault.id
}


resource "azurerm_role_assignment" "vm_vault_read" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.vm_principal_id
}
