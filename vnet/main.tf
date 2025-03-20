terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_config.name
  location            = var.vnet_config.location
  resource_group_name = var.vnet_config.resource_group_name
  address_space       = var.vnet_config.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each            = var.vnet_config.subnets
  name                = each.value.name
  resource_group_name = var.vnet_config.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.prefix]

  private_endpoint_network_policies = each.value.enable_private_endpoint ? "Disabled" : null

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

# ✅ Optional VNet Peering (if peer_with_vnets is provided)
resource "azurerm_virtual_network_peering" "vnet_peering" {
  for_each                     = var.peer_with_vnets
  name                          = "${azurerm_virtual_network.vnet.name}-to-${each.value.name}"
  resource_group_name           = var.vnet_config.resource_group_name
  virtual_network_name          = azurerm_virtual_network.vnet.name
  remote_virtual_network_id     = each.value.id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}
