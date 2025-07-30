output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "The Azure region where resources are deployed"
  value       = azurerm_resource_group.rg.location
}

output "acr_login_server" {
  description = "The login server URL for Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "container_app_name" {
  description = "The name of the Azure Container App"
  value       = azurerm_container_app.app.name
}

output "container_app_fqdn" {
  description = "The fully qualified domain name of the Container App"
  value       = azurerm_container_app.app.latest_revision_fqdn
}
