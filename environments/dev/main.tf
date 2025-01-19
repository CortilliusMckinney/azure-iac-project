# main.tf

# Purpose: Orchestrates all our infrastructure components.
# Replace the placeholder values with your specific project information.

# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 4.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

# commit a123b45: Updated environment configuration to align with project standards
locals {
  # This environment name is set for development
  environment = "dev"

  # Common tags applied to all resources
  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "Azure-IAC-Project" # Updated project name for consistency
  }
}

# commit c456d78: Configure networking module with proper segmentation
# Networking Module
module "networking" {
  source = "../../modules/networking"

  # Updated resource group naming to follow project conventions
  resource_group_name = "Azure-IAC-Project-${local.environment}-network"
  environment         = local.environment
  location            = "eastus"

  subnet_configurations = {
    application = {
      address_prefix    = "10.0.1.0/24" # 256 IPs for applications
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
    database = {
      address_prefix    = "10.0.2.0/24"
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}

# commit e789f01: Implement security module with Key Vault configuration
# Security Module
module "security" {
  source = "../../modules/security"

  resource_group_name = "Azure-IAC-Project-${local.environment}-security"
  environment         = local.environment
  location            = "eastus"
  key_vault_name      = "tfstate-${local.environment}-kv"
}

# commit g012h34: Set up compute resources for development environment
# Compute Module
module "compute" {
  source = "../../modules/compute"

  resource_group_name = "Azure-IAC-Project-${local.environment}-compute"
  environment         = local.environment
  location            = "eastus"

  vm_config = {
    name           = "Azure-IAC-Project-${local.environment}-vm"
    size           = "Standard_B2s" # Development-appropriate size
    admin_username = "adminuser"

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS" # Standard storage for development
    }
  }

  network_interface_id = module.networking.subnet_ids["application"]
  depends_on           = [module.networking]
}


