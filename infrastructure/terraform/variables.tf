variable "resource_group_name" {
  description = "Name of the new resource group for the Terraform lab."
  type        = string
  default     = "dolibarr-rg"
}

variable "location" {
  description = "Azure region for the ERP resources."
  type        = string
  default     = "eastasia"
}

variable "mysql_server_name" {
  description = "Globally unique name for the new MySQL flexible server."
  type        = string
}

variable "mysql_admin_username" {
  description = "Administrator username for the new MySQL server."
  type        = string
  default     = "doliadmin"
}

variable "mysql_admin_password" {
  description = "Administrator password for the new MySQL server."
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Globally unique name for the ERP storage account."
  type        = string
}

variable "container_registry_name" {
  description = "Globally unique name for the Azure Container Registry."
  type        = string
}

variable "webapp_name" {
  description = "Globally unique name for the new Dolibarr App Service."
  type        = string
}

variable "scm_admin_cidr" {
  description = "Temporary public IPv4 CIDR allowed to access the App Service SCM endpoint"
  type        = string
}

variable "dolibarr_db_password" {
  description = "Password for the Dolibarr MySQL application account"
  type        = string
  sensitive   = true
}

variable "dolibarr_instance_unique_id" {
  description = "Stable secret instance ID for Dolibarr"
  type        = string
  sensitive   = true
}

variable "dolibarr_admin_password" {
  description = "Initial Dolibarr ERP administrator password"
  type        = string
  sensitive   = true
}

