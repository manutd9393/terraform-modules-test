terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

resource "azurerm_resource_group" "webapp" {
  name     = var.webapp_config.resource_group_name
  location = var.webapp_config.location
}

# ✅ App Service Plan
resource "azurerm_service_plan" "webapp_plan" {
  name                = var.webapp_config.service_plan_name
  resource_group_name = azurerm_resource_group.webapp.name
  location            = azurerm_resource_group.webapp.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# ✅ App Service
resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_config.webapp_name
  resource_group_name = azurerm_resource_group.webapp.name
  location            = azurerm_service_plan.webapp_plan.location
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {}
}

# ✅ Private DNS Zone
resource "azurerm_private_dns_zone" "webapp_dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.webapp.name
}

# ✅ Private Endpoint for Web App
resource "azurerm_private_endpoint" "webapp_pe" {
  name                = "${var.webapp_config.webapp_name}-pe"
  location            = var.webapp_config.location
  resource_group_name = azurerm_resource_group.webapp.name
  subnet_id           = var.webapp_config.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.webapp_config.webapp_name}-privatelink"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.webapp_config.webapp_name}-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapp_dns.id]
  }

  depends_on = [azurerm_linux_web_app.webapp]
}

# ✅ Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "webapp_dns_link" {
  name                  = "${var.webapp_config.webapp_name}-dnslink"
  resource_group_name   = azurerm_resource_group.webapp.name
  private_dns_zone_name = azurerm_private_dns_zone.webapp_dns.name
  virtual_network_id    = var.webapp_config.vnet_id
  registration_enabled  = false
}
