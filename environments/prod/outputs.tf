# Networking Outputs
# commit 1a2b3c: Output the ID of the virtual network
# This output provides the unique ID of the virtual network created by the networking module.
output "vnet_id" {
  description = "ID of the created virtual network"
  value       = module.networking.vnet_id
}

# commit 2d3e4f: Output subnet IDs for better resource referencing
# This output gives a map of subnet names to their corresponding IDs. 
# It's useful for referencing specific subnets in other modules or resources.
output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = module.networking.subnet_ids
}

# Compute Outputs
# commit 3g4h5i: Output the ID of the virtual machine
# Outputs the unique ID of the virtual machine created in the compute module. 
# Note the change from "vm_ids" to "vm_id" for consistency with single-instance VM setups.
output "vm_id" {
  description = "ID of the created virtual machine"
  value       = module.compute.vm_id
}

# Security Outputs
# commit 6p7q8r: Output the Key Vault ID
# Provides the unique ID of the Key Vault for referencing in other modules or resources.
output "key_vault_id" {
  description = "ID of the created Key Vault"
  value       = module.security.key_vault_id
}

# commit 7r8s9t: Output the Key Vault URI
# Outputs the URI of the Key Vault, which is used to access secrets, certificates, and keys securely.
output "key_vault_uri" {
  description = "URI of the created Key Vault"
  value       = module.security.key_vault_uri
}
