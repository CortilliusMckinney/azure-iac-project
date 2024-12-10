# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Azure Resource Manager provider
      version = "~> 4.0"            # Use version 4.x for latest features and compatibility
    }
    random = {
      source  = "hashicorp/random" # Random provider for generating unique values
      version = "~> 3.0"           # Use version 3.x for stability
    }
  }
}

# Define the AzureRM provider with optional Key Vault configuration
provider "azurerm" {
  features {
    # Key Vault-specific settings (optional)
    key_vault {
      purge_soft_delete_on_destroy    = true # Automatically purge Key Vaults when destroyed
      recover_soft_deleted_key_vaults = true # Enable recovery for soft-deleted Key Vaults
    }
  }
}

# Optional: Configure Random Provider for unique names
provider "random" {}
