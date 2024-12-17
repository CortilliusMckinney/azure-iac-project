# ------------------------------
# Output Definitions for Backend Storage
# ------------------------------

resource "random_string" "storage_account_suffix" {
  length  = 8     # Generate an 8-character string
  special = false # Exclude special characters for Azure naming rules
  upper   = false # Use only lowercase for Azure storage naming rules
}

# Storage Account Name Output
# This will be needed for backend.tf configuration
output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "The name of the storage account for Terraform state"
}

# Resource Group Name Output
# Used to identify where our storage account lives
output "resource_group_name" {
  value       = azurerm_resource_group.backend.name
  description = "The resource group containing the storage account"
}

# Container Name Output
# References the blob container where state files will be stored
output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "The blob container name for state files"
}

# Common output tags
# Applied consistently across all outputs
output "tags" {
  value = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Output Values"
  }
  description = "Common output tags for backend state resources"
}
