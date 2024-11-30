resource "azurerm_resource_group" "state" {
  # Create a resource group to hold the storage account
  name     = local.resource_group_name
  location = var.location

  tags = {
    Environment = "Management"
    Purpose     = "Terraform State"
    ManagedBy   = "DevOps"
  }
}

resource "azurerm_storage_account" "state" {
  # Define the storage account for Terraform state management
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # Locally redundant storage

  # Enforce secure communication
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"  # Ensure secure TLS version
  allow_blob_public_access  = false  # Prevent public access to blobs

  blob_properties {
    versioning_enabled = true  # Enable versioning to protect state files
  }

  network_rules {
    default_action = "Deny"  # Deny all traffic unless explicitly allowed
    ip_rules       = ["203.0.113.0/24"]  # Replace with allowed IP range(s)
    bypass         = ["AzureServices"]  # Allow trusted Azure services to bypass
  }

  tags = {
    Environment = "Management"
    Purpose     = "Terraform State"
    ManagedBy   = "DevOps"
  }
}

resource "azurerm_storage_container" "state" {
  # Create a private container for storing Terraform state files
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"  # Restrict access to authorized clients
}

resource "azurerm_private_endpoint" "state_endpoint" {
  # Configure a private endpoint for secure VNet access to the storage account
  name                = "state-private-endpoint"
  location            = azurerm_resource_group.state.location
  resource_group_name = azurerm_resource_group.state.name
  subnet_id           = "<SUBNET_ID>"  # Replace with your actual subnet ID

  private_service_connection {
    name                           = "state-storage-connection"
    private_connection_resource_id = azurerm_storage_account.state.id
    is_manual_connection           = false  # Automatically establish the connection
    subresource_names              = ["blob"]  # Define connection for blob storage
  }
}

# Local values for reusability and consistency
locals {
  resource_group_name  = "terraform-state-rg"  # Name of the resource group
  storage_account_name = "tfstate${random_string.suffix.result}"  # Generate unique storage account name
}

# Generate a random string for unique resource naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}