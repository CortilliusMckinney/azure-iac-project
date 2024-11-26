# backend-config/variables.tf
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "subscription_id" {
  description = "The Azure subscription ID to use"
  type        = string
}