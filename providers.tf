# ------------------------------
# Provider Requirements
# ------------------------------
# Specify the providers required for this Terraform configuration
terraform {
  required_providers {
    # Azure provider for managing Azure resources
    azurerm = {
      source  = "hashicorp/azurerm" # Official Azure provider from HashiCorp
      version = "~> 4.0"            # Use version 4.x.x, allowing for minor updates
    }

    # Random provider for generating random values
    random = {
      source  = "hashicorp/random" # Official Random provider from HashiCorp
      version = "~> 3.0"           # Use version 3.x.x, allowing for minor updates
    }
  }
}

# ------------------------------
# Azure Provider Configuration
# ------------------------------
# Configure the Azure provider for Terraform
provider "azurerm" {
  features {
    # Enable Key Vault features for security and cleanup
    key_vault {
      purge_soft_delete_on_destroy    = true # Purge deleted Key Vaults when destroyed
      recover_soft_deleted_key_vaults = true # Automatically recover soft-deleted Key Vaults
    }
  }

  # Notes:
  # - Authentication is handled via environment variables for security:
  #   - ARM_SUBSCRIPTION_ID: Specifies the Azure subscription to use
  #   - ARM_TENANT_ID: Identifies the Azure Active Directory (AAD) tenant
  #   - ARM_CLIENT_ID: Application ID for the service principal
  #   - ARM_CLIENT_SECRET: Secret key for the service principal
}

# ------------------------------
# Random Provider Configuration
# ------------------------------
# Configure the Random provider for generating random values
provider "random" {}

# Notes:
# - The Random provider is used to create random values, such as:
#   - Unique names for resources (e.g., storage accounts)
#   - Secure passwords or tokens
