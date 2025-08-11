# Azure Resource Group name to deploy all resources into
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-hello-logger"
}

# Azure region where resources will be created
variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "UK South"
}

# Azure Container Registry name used for storing container images
variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "hellologgeracr12345xg"
}

# Name of the Azure Container App resource for the backend
variable "container_app_name" {
  description = "Name of the Azure Container App"
  type        = string
  default     = "hello-logger-app"
}

# Number of CPU cores to allocate to the container
variable "container_cpu" {
  description = "CPU cores allocated to container"
  type        = number
  default     = 0.5
}

# Memory allocated to the container in GiB format (e.g., 1.0Gi)
variable "container_memory" {
  description = "Memory allocated to container (GiB)"
  type        = string
  default     = "1.0Gi"
}

# Port number the container will listen on for requests
variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 4000
}

# Login server URL of the Azure Container Registry (e.g., hellologgeracr12345xg.azurecr.io)
variable "acr_login_server" {
  description = "Login server URL of the Azure Container Registry"
  type        = string
}
