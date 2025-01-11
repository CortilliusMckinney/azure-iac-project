# Output definitions for compute module
output "vm_id" {
  description = "ID of the created virtual machine"
  value       = azurerm_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_virtual_machine.main.name
}
output "resource_group_name" {
  description = "Name of the compute resource group"
  value       = azurerm_resource_group.compute.name
}
