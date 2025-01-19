# Configure Azure provider requirements
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Create resource group for security resources
# commit 23e5a21: Initial security resource group setup
resource "azurerm_resource_group" "security" {
  name     = "${var.environment}-${var.resource_group_name}-security"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Create Key Vault
# commit 45f8b92: Added Key Vault configuration with secure defaults
resource "azurerm_key_vault" "main" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.security.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = [] # Removed virtual_network_rules
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Secrets Management"
  }
}

# Configure Key Vault access policy
# commit 78d3e42: Added access policy for current service principal
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "List", "Create", "Delete", "Update",
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete",
  ]
}
