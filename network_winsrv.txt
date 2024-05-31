#network for WinSrv2022 VM
resource "azurerm_virtual_network" "vnet_10_10_10" {
  name                = "srv-w-1-vnet"
  address_space       = ["10.10.10.0/24"]
  location            = azurerm_resource_group.rg-srv-win.location
  resource_group_name = azurerm_resource_group.rg-srv-win.name
}

resource "azurerm_subnet" "subnet_10_10_10" {
  name                 = "subnet-10-10-10"
  resource_group_name  = azurerm_resource_group.rg-srv-win.name
  virtual_network_name = azurerm_virtual_network.vnet_10_10_10.name
  address_prefixes     = ["10.10.10.0/24"]
}

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
