resource "azurerm_resource_group" "sql" {
  name     = var.sql_config.resource_group_name
  location = var.sql_config.location
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_config.sql_server_name
  resource_group_name          = azurerm_resource_group.sql.name
  location                     = azurerm_resource_group.sql.location
  version                      = "12.0"
  administrator_login          = var.sql_config.admin_username
  administrator_login_password = var.sql_config.admin_password
}

resource "azurerm_mssql_database" "sql_db" {
  name           = var.sql_config.sql_database_name
  server_id      = azurerm_mssql_server.sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.sql_config.max_size_gb
  sku_name       = var.sql_config.sku_name
}

# Optional: Allow access from Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count = var.sql_config.allow_azure_services ? 1 : 0

  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
