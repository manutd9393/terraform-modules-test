variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_config" {
  description = "Configuration for the Virtual Network"
  type = object({
    name          = string
    address_space = list(string)
    subnets       = map(object({
      name                     = string
      prefix                   = string
      enable_private_endpoint  = optional(bool, false)
      delegation               = optional(string)
    }))
  })
}
