# main.tf
# The staging environment configuration mirrors production more closely,
# with enhanced security and redundancy for testing purposes.

# Define local variables for environment and tagging
locals {
  environment = "staging" # Specifies the environment as 'staging'.
  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "Azure-IAC-Project" # Update this to match your project's name.
  }
}

# Networking Module
# Provides production-like network segmentation for staging.
module "networking" {
  source = "../../modules/networking"

  # Use a dedicated resource group for networking resources in staging.
  resource_group_name = "Azure-IAC-Project-${local.environment}-network"
  environment         = local.environment
  location            = "eastus" # Update with your desired Azure region.

  # Define subnet configurations specific to staging.
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

# Compute Module
# Defines the compute resources with production-like performance for staging.
module "compute" {
  source = "../../modules/compute"

  resource_group_name = "Azure-IAC-Project-${local.environment}-compute"
  environment         = local.environment
  location            = "eastus"

  # VM configuration tailored for staging environment.
  vm_config = {
    name           = "Azure-IAC-Project-${local.environment}-vm" # Staging-specific VM name.
    size           = "Standard_D2s_v3"                           # Larger VM size for better performance in staging.
    admin_username = "adminuser"                                 # Replace with your admin username.

    # Configure OS disk for optimal performance.
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS" # Premium storage for higher IOPS in staging.
    }
  }

  # Attach the VM to the application subnet from the networking module.
  network_interface_id = module.networking.subnet_ids["application"]
  depends_on           = [module.networking] # Ensure networking is created first.
}

