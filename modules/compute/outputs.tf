output "vm_principal_id" {
  value = azurerm_windows_virtual_machine.vm.identity[0].principal_id
}