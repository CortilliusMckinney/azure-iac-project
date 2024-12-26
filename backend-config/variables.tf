# ------------------------------
# Backend Variables
# ------------------------------

# Environment Configuration
# -------------------------
# Specifies the environment where resources are deployed.
# Examples: "dev", "staging", "prod".
variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"

  # Validate the environment value to ensure correctness.
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be either 'dev', 'staging', or 'prod'."
  }
}

# Azure Region
# ------------
# Defines the Azure region for resource deployment.
# Default: "eastus".
variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus" # Change this to match your preferred Azure region if necessary.
}

# Network Security Rules
# ----------------------
# Specifies the list of allowed IP ranges for accessing the backend storage.
# This helps secure access to the storage account.
variable "allowed_ip_ranges" {
  type        = list(string) # Accepts a list of CIDR-formatted IP ranges.
  description = <<-EOT
    List of allowed IP ranges for accessing backend storage.
    Examples:
      - Development machine/office IP: "184.89.240.160/32"
      - GitHub Actions IP range: "20.37.158.0/23"
    Format: ["x.x.x.x/x", "y.y.y.y/y"]
  EOT

  # Validate the IP list to prevent allowing unrestricted access.
  validation {
    condition = alltrue([
      for ip in var.allowed_ip_ranges :
      can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", ip)) && # Ensure valid CIDR format.
      !can(regex("^0\\.0\\.0\\.0/0$", ip))                     # Ensure "0.0.0.0/0" is not included.
    ])
    error_message = <<-EOT
      Each IP range must be in valid CIDR format (e.g., "192.168.1.0/24")
      and cannot allow access from all IPs (0.0.0.0/0) for security reasons.
    EOT
  }
}

# Azure Subscription ID
# ----------------------
# Specifies the Azure subscription ID for resource deployment.
# It's recommended to set this via the `ARM_SUBSCRIPTION_ID` environment variable for better security.
variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID where resources will be deployed"

  # Validate the subscription ID to ensure it matches a UUID format.
  validation {
    condition     = can(regex("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$", var.subscription_id))
    error_message = "The subscription_id must be a valid UUID."
  }
}

# Resource Group Name
# -------------------
# Specifies the name of the Azure resource group that will contain all resources.
# This variable ensures flexibility across environments.
variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group for backend storage"
}

# Storage Account Prefix
# -----------------------
# Specifies a prefix for the Azure storage account name.
# This prefix will be combined with a random suffix for global uniqueness.
variable "storage_account_prefix" {
  type        = string
  description = "The prefix for the Azure storage account name"
}
