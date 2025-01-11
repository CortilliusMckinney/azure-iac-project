# Define variables for the Azure Security Module
# Resource Group
variable "resource_group_name" {
  description = "Name of the resource group where security resources will be created"
  type        = string
  # Example: "my-security-rg"
}
# Location
variable "location" {
  description = "Azure region where security resources will be created"
  type        = string
  # Default region could be "eastus" or any Azure-supported region
}
# Environment
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  # Helps in tagging resources to identify their purpose
}
# Key Vault
variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
  # Example: "my-keyvault"
}
# Network ACLs
variable "network_acls" {
  description = "Network ACLs for Key Vault"
  type = object({
    default_action = string             # Default action for unauthorized requests (e.g., "Deny")
    ip_rules       = list(string)       # List of allowed IP address ranges
    bypass         = list(string)       # Services that can bypass ACLs (e.g., "AzureServices")
  })
  default = {
    default_action = "Deny"             # Deny access by default
    ip_rules       = []                 # No IPs allowed by default
    bypass         = ["AzureServices"]  # Allow trusted Azure services
  }
  # Example:
  # network_acls = {
  #   default_action = "Deny"
  #   ip_rules       = ["203.0.113.0/24"]
  #   bypass         = ["AzureServices"]
  # }
}
# Purge Protection
variable "enable_purge_protection" {
  description = "Enable purge protection on Key Vault"
  type        = bool
  default     = true
  # Protects Key Vault from being permanently deleted
}
# Soft Delete Retention
variable "soft_delete_retention_days" {
  description = "Soft delete retention in days"
  type        = number
  default     = 7
  # Specifies how long deleted resources are retained for recovery
  # Minimum is 7 days, and maximum is 90 days
}

---
Step 14.4: Implement Main Configuration:
1. Open the existing main.tf file in VS Code:
code modules/security/main.tf
2. Copy & paste the content into the file and save:
# main.tf
# Configure required providers
# Specifies the required Terraform providers and their versions.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Azure Resource Manager provider
      version = "~> 3.0"             # Use version 3.x of the provider
    }
  }
}
# Get current Azure client configuration
# Fetches information about the currently authenticated Azure client, such as tenant ID.
data "azurerm_client_config" "current" {}
# Create resource group for security resources
# Defines a resource group specifically for security-related resources, 
# ensuring proper organization and tagging.
resource "azurerm_resource_group" "security" {
  name     = "${var.environment}-${var.resource_group_name}-security"  # Dynamic name for the resource group
  location = var.location                                              # Azure region for deployment
  tags = {
    Environment = var.environment    # Tags for environment identification (e.g., dev, prod)
    Purpose     = "Security"         # Purpose of the resource group
    ManagedBy   = "Terraform"        # Indicates the resource is managed by Terraform
  }
}
# Create Key Vault
# Configures an Azure Key Vault for secure storage of secrets and keys.
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name                       # Name of the Key Vault
  location            = azurerm_resource_group.security.location # Same location as the resource group
  resource_group_name = azurerm_resource_group.security.name      # Links to the created resource group
  tenant_id           = data.azurerm_client_config.current.tenant_id # Uses the current tenant ID
  sku_name            = "standard"                               # Standard SKU for Key Vault
  # Security features for the Key Vault
  enable_rbac_authorization   = true                             # Enable Role-Based Access Control
  purge_protection_enabled    = var.enable_purge_protection      # Protects the Key Vault from permanent deletion
  soft_delete_retention_days  = var.soft_delete_retention_days   # Number of days to retain deleted items
  enable_disk_encryption      = true                             # Enables encryption for managed disks
  enabled_for_deployment      = true                             # Allows Key Vault to be used in deployments
  # Network Access Control Lists (ACLs)
  network_acls {
    default_action = var.network_acls.default_action             # Default action for unauthorized requests (e.g., Deny)
    ip_rules       = var.network_acls.ip_rules                   # List of allowed IP ranges
    bypass         = var.network_acls.bypass                     # Services allowed to bypass ACLs (e.g., AzureServices)
  }
  tags = {
    Environment = var.environment                                # Environment tag (e.g., dev, prod)
    Purpose     = "Security"                                    # Indicates the purpose of the Key Vault
    ManagedBy   = "Terraform"                                   # Indicates the resource is managed by Terraform
  }
}
# Create diagnostic settings for Key Vault
# Configures diagnostic settings to capture logs and metrics for monitoring and auditing.
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "${var.key_vault_name}-diagnostics"    # Diagnostic setting name
  target_resource_id         = azurerm_key_vault.main.id             # Links to the Key Vault resource
  log_analytics_workspace_id = azurerm_log_analytics_workspace.security.id # Log Analytics Workspace for diagnostics
  # Logs configuration
  log {
    category = "AuditEvent"    # Captures Key Vault audit events
    enabled  = true            # Enables logging
    retention_policy {
      enabled = true           # Retain logs for a specific duration
      days    = 30             # Retain logs for 30 days
    }
  }
  # Metrics configuration
  metric {
    category = "AllMetrics"    # Captures all Key Vault metrics
    enabled  = true            # Enables metrics
    retention_policy {
      enabled = true           # Retain metrics for a specific duration
      days    = 30             # Retain metrics for 30 days
    }
  }
}