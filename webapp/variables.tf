variable "webapp_config" {
  description = "Configuration for the Web App"
  type = object({
    resource_group_name        = string
    location                   = string
    service_plan_name          = string
    webapp_name                = string
    private_endpoint_subnet_id = string
    private_dns_zone_ids       = list(string)
    vnet_id                    = string
  })
}
