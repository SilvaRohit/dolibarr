terraform {
  required_version = ">= 1.3.0"

  cloud {
    organization = "tecerotech"

    workspaces {
      name = "dolibarr-infra"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}