
# Variables for compute module
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}
variable "vm_config" {
  description = "Virtual machine configuration"
  type = object({
    name           = string
    size           = string
    admin_username = string
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
  })
}
variable "network_interface_id" {
  description = "ID of the network interface"
  type        = string
}

