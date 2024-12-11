# Configure Azure provider and specify required provider versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official Azure provider from HashiCorp
      version = "~> 4.0"            # Use version 4.x.x, allowing for minor version updates
    }
  }
}

# Configure the Azure Provider
# If using environment variables (recommended), this block can remain simple
provider "azurerm" {
  features {}
  # Credentials can be provided via environment variables:
  # ARM_SUBSCRIPTION_ID, ARM_TENANT_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET
}

# Create a resource group to contain all backend-related resources
resource "azurerm_resource_group" "backend" {
  name     = "${var.environment}-tfstate-rg" # Dynamic name based on environment
  location = var.location                    # Azure region specified in variables

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Storage"
  }
}

# Create storage account for storing Terraform state files
resource "azurerm_storage_account" "tfstate" {
  # Use a consistent naming convention that meets Azure requirements
  name                = lower(replace("${var.environment}tfstate${random_string.storage_account_suffix.result}", "-", ""))
  resource_group_name = azurerm_resource_group.backend.name
  location            = azurerm_resource_group.backend.location

  # Storage account configuration
  account_tier             = "Standard" # Standard performance tier
  account_replication_type = "LRS"      # Locally redundant storage
  min_tls_version          = "TLS1_2"   # Enforce minimum TLS version

  # Security settings
  public_network_access_enabled   = true  # Enable network access (required for remote state)
  allow_nested_items_to_be_public = false # Prevent public access to nested items
  shared_access_key_enabled       = true  # Enable access keys (required for backend)

  # Configure blob storage properties
  blob_properties {
    versioning_enabled = true # Enable versioning for state file history

    delete_retention_policy {
      days = 7 # Keep deleted blobs for 7 days
    }

    container_delete_retention_policy {
      days = 7 # Keep deleted containers for 7 days
    }
  }

  # Configure network access rules
  network_rules {
    default_action = "Deny"                # Deny all access by default
    ip_rules       = var.allowed_ip_ranges # Allow specific IP ranges
    bypass         = ["AzureServices"]     # Allow Azure services to access
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Storage"
  }
}

# Create a container for state files
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"                          # Container name
  storage_account_id    = azurerm_storage_account.tfstate.id # Reference storage account using ID
  container_access_type = "private"                          # Ensure private access only
}

# Generate a random string to ensure globally unique storage account names
resource "random_string" "storage_account_suffix" {
  length  = 8     # 8 characters long
  special = false # No special characters
  upper   = false # No uppercase letters
}

# Configure diagnostic settings for monitoring storage account activity
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "tfstate-diagnostics"
  target_resource_id         = azurerm_storage_account.tfstate.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Create Log Analytics workspace for storing diagnostic logs
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.environment}-tfstate-logs" # Environment-specific name
  location            = azurerm_resource_group.backend.location
  resource_group_name = azurerm_resource_group.backend.name
  sku                 = "PerGB2018" # Standard pricing tier
  retention_in_days   = 30          # Keep logs for 30 days

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Monitoring"
  }
}
