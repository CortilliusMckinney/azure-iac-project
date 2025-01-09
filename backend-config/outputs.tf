# ------------------------------
# Output Definitions for Backend Storage
# ------------------------------

# Storage Account Name Output
# This output provides the name of the storage account used for Terraform state.
output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "The name of the storage account for Terraform state"
}

# Resource Group Name Output
# This output identifies the resource group containing the storage account.
output "resource_group_name" {
  value       = azurerm_resource_group.backend.name
  description = "The resource group containing the storage account"
}

# Container Name Output
# This output references the name of the blob container where state files are stored.
output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "The blob container name for state files"
}

# Environment Configuration Output
# This output provides the environment-specific configuration.
output "environment_config" {
  value       = var.environment_config
  description = "Environment-specific resource configurations"
}

# Common Output Tags
# These tags are applied to all backend state resources for consistent resource tracking.
output "tags" {
  value = {
    Environment = var.environment               # Reflects the current environment (e.g., dev, staging, prod)
    ManagedBy   = "Terraform"                   # Indicates Terraform manages these resources
    Purpose     = "Backend State Output Values" # Describes the purpose of the resources
  }
  description = "Common output tags for backend state resources"
}
