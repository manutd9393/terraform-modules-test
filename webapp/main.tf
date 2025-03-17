resource "azurerm_resource_group" "webapp" {
  name     = var.webapp_config.resource_group_name
  location = var.webapp_config.location
}

resource "azurerm_service_plan" "webapp_plan" {
  name                = var.webapp_config.service_plan_name
  resource_group_name = azurerm_resource_group.webapp.name
  location            = azurerm_resource_group.webapp.location
  os_type             = "linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_config.webapp_name
  resource_group_name = azurerm_resource_group.webapp.name
  location            = azurerm_service_plan.webapp_plan.location
  service_plan_id     = azurerm_service_plan.webapp_plan.id

  site_config {}
}
