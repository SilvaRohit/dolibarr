resource "azurerm_mysql_flexible_server" "erp" {
  name                = var.mysql_server_name
  resource_group_name = azurerm_resource_group.erp.name
  location            = azurerm_resource_group.erp.location

  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  version  = "8.4"
  sku_name = "B_Standard_B1ms"

  delegated_subnet_id = azurerm_subnet.mysql.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  storage {
    size_gb           = 20
    auto_grow_enabled = true
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql
  ]
}

resource "azurerm_mysql_flexible_database" "main" {
  name                = "dolidbretry"
  resource_group_name = azurerm_resource_group.erp.name
  server_name         = azurerm_mysql_flexible_server.erp.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

moved {
  from = azurerm_mysql_flexible_database.retry
  to   = azurerm_mysql_flexible_database.main
}

# Dolibarr adds some primary keys after table creation.
# Disable Azure's generated keys to avoid conflicts.
resource "azurerm_mysql_flexible_server_configuration" "disable_generated_pk" {
  name                = "sql_generate_invisible_primary_key"
  resource_group_name = azurerm_resource_group.erp.name
  server_name         = azurerm_mysql_flexible_server.erp.name
  value               = "OFF"
}

