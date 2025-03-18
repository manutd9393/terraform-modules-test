output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnets" {
  description = "A map of subnet IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}
