# backend/main.tf

# ---------------------------------------------------------------------------------------------------------------------
# STATE STORAGE SECURITY CONFIGURATION
# This configuration establishes a secure storage account for Terraform state management with enterprise-grade security
# measures including encryption, network isolation, and access controls.
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_storage_account" "state" {
  # Basic identity and location configuration
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"  # Standard tier provides cost-effective storage with all necessary security features
  account_replication_type = "LRS"      # Locally redundant storage for state files as they're already versioned in Git

  # Communication Security Settings
  # These settings ensure all data transmission is encrypted and secure
  enable_https_traffic_only = true    # Forces all traffic to use HTTPS, preventing man-in-the-middle attacks
  min_tls_version          = "TLS1_2" # Enforces TLS 1.2 which provides strong encryption and is industry standard
  allow_blob_public_access = false    # Critical setting that prevents any public access to state files

  # Network Security Configuration
  # Implements defense-in-depth by controlling network access
  network_rules {
    default_action = "Deny"            # Implements zero-trust networking - deny all access by default
    bypass         = ["AzureServices"] # Allows only trusted Azure services to access the storage
    # ip_rules     = ["203.0.113.0/24"] # Uncomment and configure for specific trusted networks
  }

  # Data Protection Features
  # Implements safeguards against accidental or malicious data loss
  blob_properties {
    versioning_enabled = true         # Maintains state file history for audit and recovery
    delete_retention_policy {
      days = 7                        # Provides a recovery window for accidentally deleted state files
    }

    container_delete_retention_policy {
      days = 7                        # Protects against accidental container deletion
    }
  }

  # Access Tracking and Monitoring
  # Enables security monitoring and compliance
  identity {
    type = "SystemAssigned"           # Uses managed identity for secure key management
  }

  # Resource Tagging
  # Facilitates security governance and resource tracking
  tags = merge(local.common_tags, {
    Environment  = "Management"
    Purpose      = "Terraform State"
    SecurityTier = "Critical"
    ManagedBy    = "DevOps"
    DataClass    = "Sensitive"
  })

  # Lifecycle Policies
  # Implements security-focused resource management
  lifecycle {
    prevent_destroy = true            # Prevents accidental destruction of state storage
    ignore_changes  = [
      # Ignore changes to tags to prevent automation conflicts
      tags["UpdatedDate"],
      tags["UpdatedBy"]
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY MONITORING CONFIGURATION
# Implements monitoring and alerting for security-relevant events
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "state_storage" {
  name                       = "${local.storage_account_name}-diagnostics"
  target_resource_id         = azurerm_storage_account.state.id
  log_analytics_workspace_id = local.log_analytics_workspace_id

  # Audit trail for all blob operations
  log {
    category = "StorageRead"
    enabled  = true
    retention_policy {
      days    = 30
      enabled = true
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true
    retention_policy {
      days    = 30
      enabled = true
    }
  }
}