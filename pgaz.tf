provider "azurerm" {
  features {}
}

resource "azurerm_postgresql_flexible_server" "pg_flex" {
  name                   = "pgdbwebaws"
  location               = "northeurope"
  resource_group_name    = "azweb-resources"
  version                = "16"
  administrator_login    = "postgres"
  administrator_password ="!qsfzcxVsdfdsfsewr"  

  sku_name = "Standard_B1ms" # Отмечу, что этот параметр выглядит как SKU для VM, а не PostgreSQL в template.json

  storage_mb                  = 32768  # 32 GB
  backup_retention_days       = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled           = false
  public_network_access_enabled = true

  tags = {
    environment = "production"
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_ips" {
  name              = "AllowAllAzureServicesAndResourcesWithinAzureIps_2024-5-31_20-32-3"
  server_id         = azurerm_postgresql_flexible_server.pg_flex.id
  start_ip_address  = "0.0.0.0"
  end_ip_address    = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "client_ip" {
  name              = "ClientIPAddress_2024-5-31_20-29-50"
  server_id         = azurerm_postgresql_flexible_server.pg_flex.id
  start_ip_address  = "213.149.160.0"
  end_ip_address    = "213.149.170.254"
}
