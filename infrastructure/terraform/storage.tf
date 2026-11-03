resource "azurerm_storage_account" "erp" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.erp.name
  location            = azurerm_resource_group.erp.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  share_properties {
    retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_share" "documents" {
  name               = "dolibarr-documents"
  storage_account_id = azurerm_storage_account.erp.id

  quota            = 32
  enabled_protocol = "SMB"
}