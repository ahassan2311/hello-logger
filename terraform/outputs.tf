# Outputs and retrieves the name of the resource group
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

# Outputs and retrieves the Azure region where resources are deployed
output "location" {
  description = "The Azure region where resources are deployed"
  value       = azurerm_resource_group.rg.location
}

# Outputs and retrieves the login server URL for Azure Container Registry
output "acr_login_server" {
  description = "The login server URL for Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

# Outputs and retrieves the name of the Azure Container App
output "container_app_name" {
  description = "The name of the Azure Container App"
  value       = azurerm_container_app.app.name
}

# Outputs and retrieves the fully qualified domain name of the Backend Container App
output "backend_container_app_fqdn" {
  description = "The fully qualified domain name of the Backend Container App"
  value       = azurerm_container_app.app.latest_revision_fqdn
}

# Outputs and retrieves the fully qualified domain name of the Frontend Container App
output "frontend_container_app_fqdn" {
  description = "The fully qualified domain name of the Frontend Container App"
  value       = azurerm_container_app.frontend.latest_revision_fqdn
}
