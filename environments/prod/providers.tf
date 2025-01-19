
# providers.tf
# The provider configuration for production includes additional safety features
# to prevent accidental deletions and enable better security practices.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    # Prevent accidental deletion of resource groups that contain resources
    resource_group {
      prevent_deletion_if_contains_resources = true
    }

    # Enhanced Key Vault protection for production
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }

    # Virtual machine protection
    virtual_machine {
      delete_os_disk_on_deletion = false # Prevent accidental OS disk deletion
    }
  }
  subscription_id = var.subscription_id
}
