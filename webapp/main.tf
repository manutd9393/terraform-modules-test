resource "azurerm_linux_web_app" "webapp" {
  count = var.webapp_config.os_type == "Linux" ? 1 : 0  # ✅ Deploys only if Linux

  name                = var.webapp_config.webapp_name
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {
    always_on = true
    vnet_route_all_enabled = true
  }

  app_settings = merge(var.webapp_config.app_settings, {
    "WEBSITE_STACK" = var.webapp_config.runtime_stack  # ✅ Sets runtime stack dynamically
  })

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [ app_settings ]
  }
}

resource "azurerm_windows_web_app" "webapp" {
  count = var.webapp_config.os_type == "Windows" ? 1 : 0  # ✅ Deploys only if Windows

  name                = var.webapp_config.webapp_name
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {
    always_on = true
  }

  app_settings = merge(var.webapp_config.app_settings, {
    "WEBSITE_STACK" = var.webapp_config.runtime_stack  # ✅ Sets runtime stack dynamically
  })

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [ app_settings ]
  }
}
