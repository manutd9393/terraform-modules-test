terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_config.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_config.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each            = var.vnet_config.subnets
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.prefix]

  # ✅ Corrected Private Endpoint Policies
  private_endpoint_network_policies     = each.value.enable_private_endpoint ? "Disabled" : null

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [1] : []
    content {
      name = "${each.value.name}-delegation"

      service_delegation {
        name = each.value.delegation
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
  }
}
