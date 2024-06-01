resource "azurerm_linux_virtual_machine" "vm_10_6" {
  name                  = "vm-10-6"
  resource_group_name   = azurerm_resource_group.rg-azweb.name
  location              = azurerm_resource_group.rg-azweb.location
  size                  = "Standard_B2ts_v2"
  admin_username        = "ubuntu"
  network_interface_ids = [azurerm_network_interface.vm_10_6.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
   
 admin_ssh_key {
    username   = "ubuntu"
    public_key = var.ssh_public_key  
  }
#  depends_on = [azurerm_postgresql_flexible_server.pg_flex]
}

