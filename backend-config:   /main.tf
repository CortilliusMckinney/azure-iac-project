# backend-config/main.tf
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "state" {
  name     = local.resource_group_name
  location = var.location
  
  tags = {
    Environment = "Management"
    Purpose     = "Terraform State"
    ManagedBy   = "DevOps"
  }
}

resource "azurerm_storage_account" "state" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                = azurerm_resource_group.state.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  
  blob_properties {
    versioning_enabled = true
  }
  
  tags = {
    Environment = "Management"
    Purpose     = "Terraform State"
    ManagedBy   = "DevOps"
  }
}

resource "azurerm_storage_container" "state" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.state.name
  container_access_type = "private"
}

locals {
  resource_group_name   = "terraform-state-rg"
  storage_account_name  = "tfstate${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}