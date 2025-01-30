# outputs.tf

# Network outputs
output "network_info" {
  description = "Network configuration information"
  value = {
    vnet_id    = module.networking.vnet_id
    subnet_ids = module.networking.subnet_ids # If this is available in your networking module
  }
}

# Security outputs
output "security_info" {
  description = "Security configuration information"
  value = {
    key_vault_id  = module.security.key_vault_id # Changed from key_vault_name
    key_vault_uri = module.security.key_vault_uri
  }
}

# Compute outputs
output "compute_info" {
  description = "Compute configuration information"
  value = {
    vm_id   = module.compute.vm_id
    vm_name = module.compute.vm_name
  }
}
