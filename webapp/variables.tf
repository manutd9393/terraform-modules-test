variable "webapp_config" {
  description = "Configuration for the Web App"
  type = object({
    resource_group_name = string
    location            = string
    service_plan_name   = string
    webapp_name         = string
  })
}
