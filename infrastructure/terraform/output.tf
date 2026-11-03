output "resource_group_name" {
  description = "Resource group containing the new ERP lab."
  value       = azurerm_resource_group.erp.name
}

output "registry_login_server" {
  description = "Registry address used when tagging and pushing the image."
  value       = azurerm_container_registry.erp.login_server
}

output "mysql_server_fqdn" {
  description = "MySQL hostname for the Dolibarr database connection."
  value       = azurerm_mysql_flexible_server.erp.fqdn
}

output "webapp_default_hostname" {
  description = "Default Azure hostname for the new web app."
  value       = azurerm_linux_web_app.erp.default_hostname
}

output "documents_share_name" {
  description = "Azure Files share intended for Dolibarr documents."
  value       = azurerm_storage_share.documents.name
}