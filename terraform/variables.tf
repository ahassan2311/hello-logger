variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-hello-logger"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "UK South"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "hellologgeracr12345xg"
}

variable "container_app_name" {
  description = "Name of the Azure Container App"
  type        = string
  default     = "hello-logger-app"
}

variable "container_cpu" {
  description = "CPU cores allocated to container"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "Memory allocated to container (GiB)"
  type        = string
  default     = "1.0Gi"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 4000
}
