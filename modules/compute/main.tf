

resource "azurerm_resource_group" "rg_compute" {
  name     = "${var.prefix}-compute-rg"
  location = var.location
}



resource "azurerm_network_interface" "web_nic" {
  name     = "${var.prefix}-nic"
  location = azurerm_resource_group.rg_compute.location
  resource_group_name = azurerm_resource_group.rg_compute.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id 
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_windows_virtual_machine" "vm" {
  name   = "${var.prefix}-web-01"
  resource_group_name = azurerm_resource_group.rg_compute.name
  location   = azurerm_resource_group.rg_compute.location
  size       = "Standard_DC1s_v3"
  
  admin_username      = "azureadmin"
  admin_password      = var.admin_password
  patch_mode           = "AutomaticByPlatform"
  hotpatching_enabled  = false
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  network_interface_ids = [azurerm_network_interface.web_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter-Azure-Edition"
    version   = "latest"
  }
}