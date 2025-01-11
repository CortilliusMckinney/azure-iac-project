---

# outputs.tf
# This file defines outputs for Terraform to expose specific information about the deployed resources.
# Outputs allow users or other Terraform modules to access the results of Terraform's resource creation.

# Output the ID of the Azure Key Vault
# The ID is a unique identifier for the Key Vault within Azure and can be used for resource referencing.
output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}
# Output the URI of the Azure Key Vault
# The URI is the endpoint that applications use to interact with the Key Vault securely.
output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}
# Output the name of the Azure Key Vault
# The name is a human-readable identifier for the Key Vault, often used in configurations or documentation.
output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}
# Output the name of the resource group containing the security-related resources
# This is useful for identifying or managing the resource group tied to security resources.
output "resource_group_name" {
  description = "The name of the resource group containing security resources"
  value       = azurerm_resource_group.security.name
}

---