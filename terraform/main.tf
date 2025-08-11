# Configure Terraform remote state backend to store state in Azure Blob Storage
terraform {
  backend "azurerm" {
    resource_group_name   = "rg-hello-logger"           # Resource group containing the storage account
    storage_account_name  = "hellologgerstate7998"      # Storage account to hold the tfstate file
    container_name        = "tfstate"                    # Blob container inside the storage account
    key                   = "terraform.tfstate"         
  }
}

# Define required Terraform providers and their versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"                     # Use the official Azure RM provider
      version = "~> 3.99"                               # Use version 3.99 or compatible newer patch versions
    }
  }
  required_version = ">= 1.5"                           # Require Terraform version 1.5 or later
}

# Configure Azure provider with default features enabled
provider "azurerm" {
  features {}
}

# Create an Azure resource group for all resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name                   # Name specified by variable
  location = var.location                               # Azure region from variable
}

# Create Log Analytics Workspace for monitoring and diagnostics
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.resource_group_name}-logs"  # Workspace named after resource group
  location            = azurerm_resource_group.rg.location 
  resource_group_name = azurerm_resource_group.rg.name     
  sku                 = "PerGB2018"                         # Pricing tier
  retention_in_days   = 30                                   # Data retention period
}

# Create Azure Container Registry to store container images
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name                         # Registry name from variable
  resource_group_name = azurerm_resource_group.rg.name       
  location            = azurerm_resource_group.rg.location   
  sku                 = "Basic"                               
  admin_enabled       = true                                  # Enable admin user for pushing/pulling images
}

# Create Container Apps Environment for hosting container apps with integrated monitoring
resource "azurerm_container_app_environment" "env" {
  name                       = "${var.resource_group_name}-env"      # Environment named after resource group
  location                   = azurerm_resource_group.rg.location    # Same location as resource group
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id  # Link workspace for logging
}

# Backend container app configuration
resource "azurerm_container_app" "app" {
  name                         = var.container_app_name             # Backend app name from variable
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"                          # Only one active revision at a time

  template {
    container {
      name   = "hello-logger"                                   # Container name inside app
      image  = "hellologgeracr12345xg.azurecr.io/hello-logger:latest"  # Image from ACR with 'latest' tag
      cpu    = var.container_cpu                                 # CPU allocation from variable
      memory = var.container_memory                              # Memory allocation from variable
      
      env {
        name  = "PORT"                                           # Container environment variable PORT
        value = tostring(var.container_port)                     # Set from variable, converted to string
      }
    }
    
    min_replicas = 1                                             # Minimum container replicas
    max_replicas = 2                                             # Maximum container replicas (scaling)
  }

  ingress {
    external_enabled = true                                      # Enable external HTTP access
    target_port      = var.container_port                        # Port to expose externally
    transport        = "auto"                                    # Let platform choose HTTP or HTTPS

    traffic_weight {
      percentage      = 100                                      # 100% traffic to this revision
      latest_revision = true
    }
  }

  registry {
    server               = "hellologgeracr12345xg.azurecr.io"    # ACR login server
    username             = azurerm_container_registry.acr.admin_username  # Admin username from ACR
    password_secret_name = "acr-password"                        # Secret name to reference password
  }

  secret {
    name  = "acr-password"                                       # Secret to hold ACR password for container pull
    value = azurerm_container_registry.acr.admin_password       # Actual password value from ACR
  }
}

# Frontend container app configuration
resource "azurerm_container_app" "frontend" {
  name                         = "hello-logger-frontend"             # Frontend app name fixed here
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"                           # Single revision mode

  template {
    container {
      name   = "frontend"                                         # Container name inside the app
      image  = "hellologgeracr12345xg.azurecr.io/hello-logger-frontend:latest"  # Frontend image from ACR
      cpu    = 0.5                                                # CPU allocation fixed
      memory = "1.0Gi"                                            # Memory allocation fixed

      env {
        name  = "VITE_BACKEND_URL"                               # Env var to configure frontend API base URL
        value = "https://${azurerm_container_app.app.latest_revision_fqdn}/api/log"  # Backend URL from backend app FQDN
      }
    }
  }

  ingress {
    external_enabled = true                                      # Expose frontend externally
    target_port      = 80                                        # Frontend listens on port 80

    traffic_weight {
      percentage      = 100                                      # 100% traffic to latest revision
      latest_revision = true
    }
  }

  registry {
    server               = "hellologgeracr12345xg.azurecr.io"    # ACR login server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-password-frontend"               # Secret name for ACR password (frontend)
  }

  secret {
    name  = "acr-password-frontend"                              # Secret storing ACR password for frontend
    value = azurerm_container_registry.acr.admin_password
  }
}