resource "azurerm_container_registry" "erp" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.erp.name
  location            = azurerm_resource_group.erp.location

  sku                  = "Basic"
  admin_enabled        = false
  role_assignment_mode = "LegacyRegistryPermissions"
}

