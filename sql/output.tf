output "sql_server_name" {
  description = "The name of the Azure SQL Server"
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_database_name" {
  description = "The name of the Azure SQL Database"
  value       = azurerm_mssql_database.sql_db.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the SQL Server"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
