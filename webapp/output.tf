output "webapp_name" {
  description = "The name of the deployed Web App"
  value       = azurerm_linux_web_app.webapp.name
}

output "webapp_url" {
  description = "The default URL of the Web App"
  value       = azurerm_linux_web_app.webapp.default_hostname
}
