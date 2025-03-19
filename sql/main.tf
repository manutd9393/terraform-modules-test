terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

resource "azurerm_resource_group" "sql" {
  name     = var.sql_config.resource_group_name
  location = var.sql_config.location
}

# ✅ SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_config.sql_server_name
  resource_group_name          = azurerm_resource_group.sql.name
  location                     = azurerm_resource_group.sql.location
  version                      = "12.0"
  administrator_login          = var.sql_config.admin_username
  administrator_login_password = var.sql_config.admin_password
}

# ✅ SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name           = var.sql_config.sql_database_name
  server_id      = azurerm_mssql_server.sql_server.id
  sku_name       = var.sql_config.sku_name
  max_size_gb    = var.sql_config.max_size_gb
}

# ✅ Private DNS Zone for SQL
resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.sql.name
}

# ✅ Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${var.sql_config.sql_server_name}-pe"
  location            = var.sql_config.location
  resource_group_name = azurerm_resource_group.sql.name
  subnet_id           = var.sql_config.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.sql_config.sql_server_name}-privatelink"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.sql_config.sql_server_name}-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns.id]
  }

  depends_on = [azurerm_mssql_server.sql_server]
}

# ✅ Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  name                  = "${var.sql_config.sql_server_name}-dnslink"
  resource_group_name   = azurerm_resource_group.sql.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  virtual_network_id    = var.sql_config.vnet_id
  registration_enabled  = false
}

