variable "vnet_config" {
  description = "Configuration for the Virtual Network"
  type = object({
    name                = string
    address_space       = list(string)
    resource_group_name = string
    location            = string
    subnets             = map(object({
      name                     = string
      prefix                   = string
      enable_private_endpoint  = optional(bool, false)
      delegation               = optional(string)
    }))
  })
}

variable "peer_with_vnets" {
  description = "A map of VNets to peer with"
  type = map(object({
    name = string
    id   = string
  }))
  default = {}  # ✅ Default is empty (no peering for now)
}
