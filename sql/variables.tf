variable "sql_config" {
  description = "Configuration for SQL Server & Database"
  type = object({
    resource_group_name   = string
    location             = string
    sql_server_name      = string
    sql_database_name    = string
    admin_username       = string
    admin_password       = string
    sku_name             = string
    max_size_gb          = number
    private_endpoint_subnet_id = string
    private_dns_zone_ids       = list(string)
    vnet_id                    = string
  })
}
