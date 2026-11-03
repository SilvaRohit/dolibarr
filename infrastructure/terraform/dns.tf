resource "azurerm_private_dns_zone" "mysql" {
  name                = "dolibarr-dnszone.private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.erp.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "dolibarr-vnet-linke"
  resource_group_name   = azurerm_resource_group.erp.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.erp.id

  registration_enabled = false
}