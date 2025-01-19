# commit 87d3a1b: Initial environment and resource group variables
# Defined basic variables for environment, resource group, and location.

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Base name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

# commit c9b4f72: Added storage account variables
# Introduced variables for configuring storage account name and replication type with validation.

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters long and contain only lowercase letters and numbers."
  }
}

variable "replication_type" {
  type        = string
  description = "Storage replication type"
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS."
  }
}

# commit f2e8c9d: Added network rules variable with defaults
# Added support for network rules, including default actions, IP whitelisting, and bypass options.

variable "network_rules" {
  type = object({
    default_action = string
    ip_rules       = list(string)
    bypass         = list(string)
  })
  description = "Network rules for the storage account including IP whitelist and bypass options"

  validation {
    condition     = contains(["Allow", "Deny"], var.network_rules.default_action)
    error_message = "Default action must be either 'Allow' or 'Deny'."
  }

  validation {
    condition = alltrue([
      for rule in var.network_rules.bypass : contains(["AzureServices", "None"], rule)
    ])
    error_message = "Bypass values must be either 'AzureServices' or 'None'."
  }

  default = {
    default_action = "Deny"
    ip_rules       = []
    bypass         = ["AzureServices"]
  }
}
