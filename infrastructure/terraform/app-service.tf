resource "azurerm_service_plan" "erp" {
  name                = "asp-dolibarr-terraform"
  resource_group_name = azurerm_resource_group.erp.name
  location            = azurerm_resource_group.erp.location

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "erp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.erp.name
  location            = azurerm_resource_group.erp.location
  service_plan_id     = azurerm_service_plan.erp.id

  # Keep the app stopped during initial infrastructure deployment.
  enabled    = true
  https_only = true

  virtual_network_subnet_id = azurerm_subnet.app_integration.id

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.app_acr_pull.id
    ]
  }

  site_config {
    always_on  = true
    ftps_state = "Disabled"

    container_registry_use_managed_identity = true

    container_registry_managed_identity_client_id = (
      azurerm_user_assigned_identity.app_acr_pull.client_id
    )

    application_stack {
      docker_image_name   = "dolibarr-tls:24.0.2-php8.5"
      docker_registry_url = "https://${azurerm_container_registry.erp.login_server}"
    }

    ip_restriction_default_action     = "Deny"
    scm_use_main_ip_restriction       = false
    scm_ip_restriction_default_action = "Deny"

    scm_ip_restriction {
      name       = "temporary-admin-access"
      ip_address = var.scm_admin_cidr
      action     = "Allow"
      priority   = 100
    }

    ip_restriction {
      name       = "temporary-erp-access"
      ip_address = var.scm_admin_cidr
      action     = "Allow"
      priority   = 100
    }
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name
    ]
  }

  storage_account {
    name         = "dolibarrdocs"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.erp.name
    share_name   = azurerm_storage_share.documents.name
    access_key   = azurerm_storage_account.erp.primary_access_key
    mount_path   = "/var/www/documents"
  }

  app_settings = {
    DOLI_DB_HOST     = azurerm_mysql_flexible_server.erp.fqdn
    DOLI_DB_NAME     = azurerm_mysql_flexible_database.main.name
    DOLI_DB_USER     = "dolibarr_app"
    DOLI_DB_PASSWORD = var.dolibarr_db_password

    DOLI_DB_TYPE      = "mysqli"
    DOLI_DB_HOST_PORT = "3306"
    DOLI_DB_SSL       = "true"

    DOLI_INSTANCE_UNIQUE_ID             = var.dolibarr_instance_unique_id
    DOLI_URL_ROOT                       = "https://dolibarr-application.azurewebsites.net"
    DOLI_INIT_DEMO                      = "0"
    WEBSITES_PORT                       = "80"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOLI_INSTALL_AUTO                   = "0"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "1800"
    DOLI_ADMIN_LOGIN                    = "erpadmin"
    DOLI_ADMIN_PASSWORD                 = var.dolibarr_admin_password

  }

  depends_on = [
    azurerm_role_assignment.app_acr_pull
  ]
}