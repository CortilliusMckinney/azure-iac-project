# commit 23e5a21: Initial security module variables
# Added basic variables for defining the resource group, environment, and location.

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region"
}

# commit 45f8b92: Added Key Vault variables
# Introduced a variable to define the Key Vault name with validation for proper formatting.

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.key_vault_name))
    error_message = "Key vault name must be 3-24 characters long and contain only alphanumeric characters and hyphens."
  }
}
