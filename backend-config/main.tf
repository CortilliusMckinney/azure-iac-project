# ------------------------------
# Configure Azure Provider and Backend Infrastructure
# ------------------------------

# Specify required providers and versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official Azure provider from HashiCorp
      version = "~> 4.0"            # Use version 4.x.x, allowing for minor updates
    }
  }
}

# Initialize the Azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {} # Enable default Azure features
}

# ------------------------------
# Resource Group Configuration
# ------------------------------

# Create a resource group for backend storage resources
resource "azurerm_resource_group" "backend" {
  name     = var.resource_group_name # Dynamically set resource group name
  location = var.location            # Set location dynamically
  tags = {
    Environment = var.environment         # Tag with environment name
    ManagedBy   = "Terraform"             # Indicate Terraform is managing this resource
    Purpose     = "Backend State Storage" # Describe the purpose of the resource group
  }
}

# ------------------------------
# Storage Account Configuration
# ------------------------------

# Create a storage account to host Terraform state files
resource "azurerm_storage_account" "tfstate" {
  name                            = "${var.storage_account_prefix}${random_string.storage_account_suffix.result}" # Generate a unique name
  resource_group_name             = azurerm_resource_group.backend.name
  location                        = azurerm_resource_group.backend.location
  account_tier                    = "Standard" # Standard performance tier
  account_replication_type        = "LRS"      # Locally redundant storage
  min_tls_version                 = "TLS1_2"   # Enforce minimum TLS version
  public_network_access_enabled   = true       # Allow public network access for remote state
  allow_nested_items_to_be_public = false      # Restrict public access to nested items
  shared_access_key_enabled       = true       # Enable access keys for authentication

  # Enable versioning and configure retention policies
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7 # Retain deleted blobs for 7 days
    }
    container_delete_retention_policy {
      days = 7 # Retain deleted containers for 7 days
    }
  }

  # Define network access rules
  network_rules {
    default_action = "Deny"                # Deny access by default
    ip_rules       = var.allowed_ip_ranges # Allow access from defined IP ranges
    bypass         = ["AzureServices"]     # Permit access from Azure services
  }

  # Add resource tags for management
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Storage"
  }
}

# ------------------------------
# Blob Container Configuration
# ------------------------------

# Create a blob container for state file storage
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"                          # Name the container
  storage_account_id    = azurerm_storage_account.tfstate.id # Link to storage account
  container_access_type = "private"                          # Restrict access to private
}

# ------------------------------
# Log Analytics Workspace Configuration
# ------------------------------

# Create a Log Analytics workspace to monitor backend resources
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.resource_group_name}-logs" # Name the workspace dynamically
  location            = var.location                      # Set location dynamically
  resource_group_name = var.resource_group_name           # Assign to the same resource group
  sku                 = "PerGB2018"                       # Use pay-as-you-go pricing
  retention_in_days   = 30                                # Retain logs for 30 days

  # Add resource tags for management
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Monitoring"
  }
}

# ------------------------------
# Diagnostic Settings for Monitoring
# ------------------------------

# Enable diagnostic settings for the storage account
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "tfstate-diagnostics"                   # Name the diagnostic setting
  target_resource_id         = azurerm_storage_account.tfstate.id      # Link to the storage account
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id # Link to the workspace

  # Enable transaction metrics
  metric {
    category = "Transaction"
    enabled  = true
  }
}

# ------------------------------
# Random String Generator for Storage Account Name
# ------------------------------

# Generate a random suffix for the storage account name
resource "random_string" "storage_account_suffix" {
  length  = 8     # Generate an 8-character string
  special = false # Exclude special characters for Azure naming rules
  upper   = false # Use only lowercase for Azure storage naming rules
}
