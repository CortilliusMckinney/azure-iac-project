# ------------------------------
# Backend Variables
# ------------------------------

# Environment Configuration
# -----------------------
variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"

  # Add validation to prevent mistakes
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be either 'dev', 'staging', or 'prod'."
  }
}

# Azure Region
# -----------
variable "location" {
  type        = string
  description = "Azure region for resources"

  # Default to East US for consistency
  default = "eastus"
}

# Network Security
# ---------------
# Network Security
# ---------------
variable "allowed_ip_ranges" {
  type        = list(string) # Changed from 'string' to 'list(string)'
  description = <<-EOT
    IP ranges that can access the storage account:
    - Development team IPs
    - CI/CD pipeline IPs (GitHub Actions)
    - Any other authorized access points
    Format: ["x.x.x.x/x", "y.y.y.y/y"]
  EOT

  # Validation for list elements instead of the whole string
  validation {
    condition = alltrue([
      for ip in var.allowed_ip_ranges :
      !can(regex("^0\\.0\\.0\\.0/0$", ip))
    ])
    error_message = "Cannot allow access from all IPs (0.0.0.0/0) for security reasons."
  }
}

# Azure Subscription
# ----------------
# Note: We keep this for reference but typically use ARM_SUBSCRIPTION_ID 
# environment variable instead for security
variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID where resources will be deployed"

  # Add validation for subscription ID format
  validation {
    condition     = can(regex("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$", var.subscription_id))
    error_message = "The subscription_id must be a valid UUID."
  }
}
