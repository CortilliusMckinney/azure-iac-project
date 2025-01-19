# main.tf
# Production environment configuration with enhanced security and redundancy.

# commit a123b45: Updated production environment configuration for consistent naming
locals {
  environment = "prod" # Specifies the environment as 'prod'.
  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "Azure-IAC-Project" # Updated project name for consistency
  }
}

# commit b234c56: Enhanced networking configuration for production
# Networking Module
# Provides production network segmentation.
module "networking" {
  source = "../../modules/networking"

  # Use a dedicated resource group for networking resources in production.
  resource_group_name = "Azure-IAC-Project-${local.environment}-network"
  environment         = local.environment
  location            = "eastus" # Update with your desired Azure region.

  # Define subnet configurations specific to production.
  subnet_configurations = {
    application = {
      address_prefix    = "10.0.1.0/24" # Subnet for application resources.
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]
    }
    database = {
      address_prefix    = "10.0.2.0/24" # Subnet for database resources.
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}

# commit c345d67: Implemented enhanced security configuration for production
# Security Module
# Handles security enhancements, such as Key Vault and restricted access.
module "security" {
  source = "../../modules/security"

  # Security resources in their own resource group.
  resource_group_name = "Azure-IAC-Project-${local.environment}-security"
  environment         = local.environment
  location            = "eastus"
  key_vault_name      = "tfstate-${local.environment}-kv" # Key Vault for secure secrets management.
}

# commit d456e78: Configured production-grade compute resources
# Compute Module
# Defines the production compute resources.
module "compute" {
  source = "../../modules/compute"

  resource_group_name = "Azure-IAC-Project-${local.environment}-compute"
  environment         = local.environment
  location            = "eastus"

  # VM configuration tailored for production environment.
  vm_config = {
    name           = "Azure-IAC-Project-${local.environment}-vm" # Production-specific VM name.
    size           = "Standard_D4s_v3"                           # Larger VM size for production performance.
    admin_username = "adminuser"                                 # Replace with your admin username.

    # Configure OS disk for optimal performance.
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS" # Premium storage for higher IOPS in production.
    }
  }

  # Attach the VM to the application subnet from the networking module.
  network_interface_id = module.networking.subnet_ids["application"]
  depends_on           = [module.networking] # Ensure networking is created first.
}


