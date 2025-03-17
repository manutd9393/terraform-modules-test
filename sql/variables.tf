variable "sql_config" {
  description = "Configuration for Azure SQL Server and Database"
  type = object({
    resource_group_name   = string
    location             = string
    sql_server_name      = string
    sql_database_name    = string
    admin_username       = string
    admin_password       = string
    sku_name             = optional(string, "Basic")  # e.g., "S0", "S1", "P1"
    max_size_gb          = optional(number, 5)       # Default 5 GB
    allow_azure_services = optional(bool, true)      # Whether to allow Azure services to connect
  })
}
