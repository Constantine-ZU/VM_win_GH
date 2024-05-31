



resource "azurerm_public_ip" "public_vm_ip" {
  name                = "srv-w-1-ip"
  location            = azurerm_resource_group.rg-srv-win.location
  resource_group_name = azurerm_resource_group.rg-srv-win.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.dns_comp_name

}

resource "azurerm_network_interface" "nic_vm" {
  name                = "vmwin2022-nic"
  location            = azurerm_resource_group.rg-srv-win.location
  resource_group_name = azurerm_resource_group.rg-srv-win.name

  ip_configuration {
    name                          = "internal-vmwin2022-ip"
    subnet_id                     = azurerm_subnet.subnet_10_10_10.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.10.8" 
    public_ip_address_id          = azurerm_public_ip.public_vm_ip.id
  }
}

resource "azurerm_windows_virtual_machine" "example_vm" {
  name                = "vmwin2022-vm"
  resource_group_name = azurerm_resource_group.rg-srv-win.name
  location            = azurerm_resource_group.rg-srv-win.location
  size                = "Standard_E2s_v3"
  admin_username      = var.win_user
  admin_password      = var.win_password 
  network_interface_ids = [
    azurerm_network_interface.nic_vm.id,
  ]
  computer_name       = "vmwin2022"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-hotpatch"   #"2022-datacenter-azure-edition-gen2"
    version   = "latest"
  }




 enable_automatic_updates = true
  patch_mode               = "AutomaticByPlatform"


}


output "vm_id" {
  value = azurerm_windows_virtual_machine.example_vm.id
}