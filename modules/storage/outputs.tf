# commit 12d5e90: Added output definitions
output "storage_account_id" {
  description = "Storage Account ID"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.main.name
}

output "default_container_name" {
  description = "Name of the default storage container"
  value       = azurerm_storage_container.default.name
}

output "primary_blob_endpoint" {
  description = "Primary blob storage endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "resource_group_name" {
  description = "Name of the storage resource group"
  value       = azurerm_resource_group.storage.name
}
