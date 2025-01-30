# environments/variables.tf

#####################################
# Core Configuration Variables
#####################################

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be either 'dev', 'staging', or 'prod'."
  }
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "The name of the project, used in resource naming"
  type        = string
}

#####################################
# Network Configuration
#####################################

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access resources"
  type        = list(string)
}

#####################################
# Compute Configuration
#####################################

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for VMs"
  type        = string
}

#####################################
# Environment-Specific Configurations
#####################################

variable "environment_config" {
  description = "Environment-specific resource configurations"
  type = map(object({
    vm_size             = string
    instance_count      = number
    retention_days      = number
    backup_enabled      = bool
    monitoring_interval = string
  }))

  default = {
    dev = {
      vm_size             = "Standard_B1s"
      instance_count      = 1
      retention_days      = 30
      backup_enabled      = false
      monitoring_interval = "PT5M"
    }
    staging = {
      vm_size             = "Standard_B2s"
      instance_count      = 2
      retention_days      = 60
      backup_enabled      = true
      monitoring_interval = "PT1M"
    }
    prod = {
      vm_size             = "Standard_D2s_v3"
      instance_count      = 3
      retention_days      = 90
      backup_enabled      = true
      monitoring_interval = "PT30S"
    }
  }
}

#####################################
# Authentication Variables 
# (Used only for validation - values come from environment variables)
#####################################

variable "tenant_id" {
  description = "The tenant ID of the Azure subscription"
  type        = string
  default     = null # Make it optional
}

variable "client_id" {
  description = "The client ID for the Azure service principal"
  type        = string
  default     = null # Make it optional
}

variable "client_secret" {
  description = "The client secret for the Azure service principal"
  type        = string
  sensitive   = true
  default     = null # Make it optional
}

variable "subscription_id" {
  description = "Azure subscription ID where resources will be created"
  type        = string
  default     = null # Make it optional
}
