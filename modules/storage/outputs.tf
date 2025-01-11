# outputs.tf - Define the outputs for the storage module
output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}
output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}
output "resource_group_name" {
  description = "Name of the storage resource group"
  value       = azurerm_resource_group.storage.name
}
