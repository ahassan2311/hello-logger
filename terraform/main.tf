terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99"
    }
  }
  required_version = ">= 1.5"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.resource_group_name}-logs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "env" {
  name                       = "${var.resource_group_name}-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  template {
    container {
      name   = "hello-logger"
      image  = "hellologgeracr12345xg.azurecr.io/hello-logger:latest"
      cpu    = var.container_cpu
      memory = var.container_memory
      
      env {
        name  = "PORT"
        value = tostring(var.container_port)
      }
    }
    
    min_replicas = 1
    max_replicas = 2
  }

  ingress {
    external_enabled = true
    target_port      = var.container_port
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server               = "hellologgeracr12345xg.azurecr.io"
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }
}

resource "azurerm_container_app" "frontend" {
  name                         = "hello-logger-frontend"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend"
      image = "hellologgeracr12345xg.azurecr.io/hello-logger-frontend:latest"
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "VITE_BACKEND_URL"
        value = "https://${azurerm_container_app.app.latest_revision_fqdn}/api/log"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
  }
  }
  registry {
    server               = "hellologgeracr12345xg.azurecr.io"
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-password-frontend"
  }

  secret {
    name  = "acr-password-frontend"
    value = azurerm_container_registry.acr.admin_password
}
}