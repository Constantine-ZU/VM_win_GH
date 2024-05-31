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