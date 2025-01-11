# main.tf - Main configuration for the storage module
# This file defines the core resources for the Azure storage infrastructure, including the provider, resource group, and storage account.

# Configure the Terraform AzureRM provider
# Specifies the provider plugin for Azure and the version constraints to use.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Provider for Azure resources
      version = "~> 4.0"            # Compatible with version 4.x
    }
  }
}
# Create a resource group for the storage account
# Resource groups are containers for managing Azure resources.
resource "azurerm_resource_group" "storage" {
  name     = "${var.environment}-${var.resource_group_name}" # Dynamic name based on environment and variable input
  location = var.location                                    # Location for the resource group (e.g., East US)
  # Tags help organize and manage resources in Azure
  tags = {
    Environment = var.environment # Environment identifier (e.g., dev, prod)
    ManagedBy   = "Terraform"     # Indicates Terraform manages this resource
  }
}
# Create an Azure storage account
# The storage account is the foundation for Azure Blob, Queue, Table, and File storage services.
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name                # Unique name for the storage account
  resource_group_name      = azurerm_resource_group.storage.name     # Associates the account with the created resource group
  location                 = azurerm_resource_group.storage.location # Matches the location of the resource group
  account_tier             = "Standard"                              # Specifies the performance tier (Standard or Premium)
  account_replication_type = var.replication_type                    # Defines replication strategy (e.g., LRS, GRS)
  # Security settings for the storage account
  enable_https_traffic_only = var.enable_https_only        # Enforces HTTPS for secure access
  min_tls_version           = var.min_tls_version          # Specifies the minimum TLS version (e.g., TLS 1.2)
  allow_blob_public_access  = var.allow_blob_public_access # Controls public access to blobs
  # Blob service-specific properties
  blob_properties {
    versioning_enabled = true # Enables blob versioning for data protection
    delete_retention_policy {
      days = 7 # Retains deleted blobs for 7 days
    }
  }
  # Tags help categorize the storage account for billing and management
  tags = {
    Environment = var.environment       # Specifies the environment (e.g., dev, staging)
    ManagedBy   = "Terraform"           # Indicates Terraform manages this resource
    Purpose     = "Application Storage" # Describes the resource's purpose
  }
}
