variable "webapp_config" {
  description = "Configuration for the Web App"
  type = object({
    resource_group_name       = string
    location                  = string
    webapp_name               = string
    service_plan_name         = string
    os_type                   = string  # "Linux" or "Windows"
    runtime_stack             = string  # "PHP|8.3", "NODE|18", "DOTNET|6.0"
    sku_name                  = optional(string, "P1v2")
    app_settings              = optional(map(string), {})
    private_endpoint_subnet_id = optional(string, null)
  })
}
