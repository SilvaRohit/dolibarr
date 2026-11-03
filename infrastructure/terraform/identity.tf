resource "azurerm_user_assigned_identity" "app_acr_pull" {
  name                = "id-dolibarr-acr-pull"
  resource_group_name = azurerm_resource_group.erp.name
  location            = azurerm_resource_group.erp.location
}

resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = azurerm_container_registry.erp.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.app_acr_pull.principal_id

  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}