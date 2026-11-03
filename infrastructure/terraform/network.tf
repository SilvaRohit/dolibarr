resource "azurerm_resource_group" "erp" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "erp" {
  name                = "vnet-dolibarr"
  location            = azurerm_resource_group.erp.location
  resource_group_name = azurerm_resource_group.erp.name

  address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "app_integration" {
  name                 = "snet-app-integration"
  resource_group_name  = azurerm_resource_group.erp.name
  virtual_network_name = azurerm_virtual_network.erp.name

  address_prefixes = ["10.1.1.0/26"]

  delegation {
    name = "app-service-delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet" "mysql" {
  name                 = "snet-mysql"
  resource_group_name  = azurerm_resource_group.erp.name
  virtual_network_name = azurerm_virtual_network.erp.name

  address_prefixes = ["10.1.2.0/27"]

  delegation {
    name = "mysql-delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}