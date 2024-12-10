# Configure Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "backend" {
  name     = "${var.environment}-tfstate-rg"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Storage"
  }
}

# Create storage account for Terraform state
resource "azurerm_storage_account" "tfstate" {
  name                            = "${var.environment}tfstate${random_string.storage_account_suffix.result}"
  resource_group_name             = azurerm_resource_group.backend.name
  location                        = azurerm_resource_group.backend.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    default_action = "Deny"
    ip_rules       = var.allowed_ip_ranges
    bypass         = ["AzureServices"]
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Storage"
  }
}

# Create container for Terraform state
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Generate random suffix for storage account name
resource "random_string" "storage_account_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enable diagnostic settings for the storage account
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

# Create Log Analytics workspace for diagnostics
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.environment}-tfstate-logs"
  location            = azurerm_resource_group.backend.location
  resource_group_name = azurerm_resource_group.backend.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Monitoring"
  }
}
