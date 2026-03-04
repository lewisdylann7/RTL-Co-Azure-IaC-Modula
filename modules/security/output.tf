output "key_vault_secret_value" {
  value = azurerm_key_vault_secret.vm_password.value
  sensitive = true
}