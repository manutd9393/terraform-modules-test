resource "azurerm_resource_group" "webapp" {
  name     = var.webapp_config.resource_group_name
  location = var.webapp_config.location
}

resource "azurerm_service_plan" "webapp_plan" {
  name                = var.webapp_config.service_plan_name
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  os_type             = var.webapp_config.os_type
  sku_name            = var.webapp_config.sku_name
}

# Linux Web App
resource "azurerm_linux_web_app" "webapp" {
  count = var.webapp_config.os_type == "Linux" ? 1 : 0  # Deploys only if Linux

  name                = var.webapp_config.webapp_name
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {
    always_on       = true
    linux_fx_version = var.webapp_config.runtime_stack  # e.g., "PHP|8.3", "NODE|18"
    vnet_route_all_enabled = true
  }

  app_settings = var.webapp_config.app_settings

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [ app_settings ]
  }
}

# Windows Web App
resource "azurerm_windows_web_app" "webapp" {
  count = var.webapp_config.os_type == "Windows" ? 1 : 0  # Deploys only if Windows

  name                = var.webapp_config.webapp_name
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {
    always_on         = true
    windows_fx_version = var.webapp_config.runtime_stack  # e.g., "DOTNET|6.0"
  }

  app_settings = var.webapp_config.app_settings

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [ app_settings ]
  }
}
