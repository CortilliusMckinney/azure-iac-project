# environments/variables.tf

# Environment Type
# This variable determines the current environment for resource deployment.
# Valid options are restricted to 'dev', 'staging', or 'prod' for consistency.
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)     # Ensures only valid environments are used
    error_message = "Environment must be either 'dev', 'staging', or 'prod'." # User-friendly error message
  }
}

# Azure Region Configuration
# Specifies the Azure region where resources will be deployed.
# Default value is 'eastus' for standardization unless overridden.
variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus" # Default Azure region
}

# Resource Configuration by Environment
# This variable is a map defining environment-specific resource configurations.
# Each environment (dev, staging, prod) has tailored settings for:
# - VM size
# - Instance count
# - Data retention period
# - Backup settings
# - Monitoring intervals
variable "environment_config" {
  description = "Environment-specific resource configurations"
  type = map(object({
    vm_size             = string # Specifies the size of the virtual machine
    instance_count      = number # Number of instances to deploy
    retention_days      = number # Data retention period in days
    backup_enabled      = bool   # Whether backup is enabled for this environment
    monitoring_interval = string # Monitoring interval for health checks
  }))

  default = {
    # Development environment configurations
    dev = {
      vm_size             = "Standard_B1s" # Cost-effective VM for development
      instance_count      = 1              # Single instance for dev
      retention_days      = 30             # 30-day data retention
      backup_enabled      = false          # Backup disabled to reduce costs
      monitoring_interval = "PT5M"         # Monitoring every 5 minutes
    }
    # Staging environment configurations
    staging = {
      vm_size             = "Standard_B2s" # Moderate VM size for staging
      instance_count      = 2              # Two instances for staging
      retention_days      = 60             # 60-day data retention
      backup_enabled      = true           # Backup enabled for safety
      monitoring_interval = "PT1M"         # Monitoring every 1 minute
    }
    # Production environment configurations
    prod = {
      vm_size             = "Standard_D2s_v3" # High-performance VM for production
      instance_count      = 3                 # Three instances for load handling
      retention_days      = 90                # 90-day data retention
      backup_enabled      = true              # Backup enabled for reliability
      monitoring_interval = "PT30S"           # Monitoring every 30 seconds for high availability
    }
  }
}
