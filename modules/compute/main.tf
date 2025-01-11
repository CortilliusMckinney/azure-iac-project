# Configure Azure provider requirements
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Create resource group for compute resources
resource "azurerm_resource_group" "compute" {
  name     = "${var.environment}-${var.resource_group_name}"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
# Create virtual machine
resource "azurerm_virtual_machine" "main" {
  name                = var.vm_config.name
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name
  vm_size             = var.vm_config.size

  network_interface_ids = [var.network_interface_id]
  storage_os_disk {
    name              = "${var.vm_config.name}-os-disk"
    caching           = var.vm_config.os_disk.caching
    create_option     = "FromImage"
    managed_disk_type = var.vm_config.os_disk.storage_account_type
  }
  os_profile {
    computer_name  = var.vm_config.name
    admin_username = var.vm_config.admin_username
  }
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
