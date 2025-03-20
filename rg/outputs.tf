output "resource_group_names" {
  description = "A map of created Resource Groups and their locations"
  value       = { for k, v in azurerm_resource_group.rg : k => v.name }
}

output "resource_group_locations" {
  description = "A map of created Resource Group locations"
  value       = { for k, v in azurerm_resource_group.rg : k => v.location }
}
