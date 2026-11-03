resource "azurerm_app_service_custom_hostname_binding" "erp" {
  hostname            = "erp.tecerotech.com"
  app_service_name    = azurerm_linux_web_app.erp.name
  resource_group_name = azurerm_resource_group.erp.name

  # The certificate binding manages these fields.
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "erp" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.erp.id
}

resource "azurerm_app_service_certificate_binding" "erp" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.erp.id
  certificate_id      = azurerm_app_service_managed_certificate.erp.id
  ssl_state           = "SniEnabled"
}
