# Configure Azure provider requirements
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Create resource group for storage resources
# commit 34a1b56: Initial storage resource group setup
resource "azurerm_resource_group" "storage" {
  name     = "${var.environment}-${var.resource_group_name}"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Create storage account
# commit 89c4d23: Enhanced storage account configuration
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  min_tls_version          = "TLS1_2"

  network_rules {
    default_action = var.network_rules.default_action
    ip_rules       = var.network_rules.ip_rules
    bypass         = var.network_rules.bypass
  }

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Application Storage"
  }
}

# Create default container
# commit abc123d: Added default container
# Update the deprecated reference
resource "azurerm_storage_container" "default" {
  name                  = "default"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
