# Main Terraform configuration for backend storage with enterprise-grade security and monitoring

resource "azurerm_storage_account" "state" {
  # Storage account for Terraform state management
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"              # Cost-effective storage tier
  account_replication_type = "LRS"                   # Locally redundant storage (LRS) for state files

  # Communication security settings
  enable_https_traffic_only = true                   # Enforce HTTPS-only access to prevent MITM attacks
  min_tls_version           = "TLS1_2"               # Enforce TLS 1.2 for secure communication
  allow_blob_public_access  = false                  # Disable public access to blob storage

  # Blob storage properties for versioning and deletion protection
  blob_properties {
    versioning_enabled = true                        # Enable versioning for recovery and audit purposes
    delete_retention_policy {
      days = 7                                       # Retain deleted blobs for 7 days
    }
    container_delete_retention_policy {
      days = 7                                       # Retain deleted containers for 7 days
    }
  }

  # Network security configuration
  network_rules {
    default_action = "Deny"                          # Deny all traffic unless explicitly allowed
    ip_rules       = ["203.0.113.0/24"]              # Replace with allowed IP range(s)
    bypass         = ["AzureServices"]               # Allow trusted Azure services to bypass rules
  }

  # Enable system-assigned managed identity for secure resource access
  identity {
    type = "SystemAssigned"                          # Use a managed identity to eliminate static credentials
  }

  # Tags for resource categorization and governance
  tags = {
    Environment = "Management"                      # Logical environment categorization
    Purpose     = "Terraform State"                # Purpose description for the resource
    ManagedBy   = "DevOps"                          # Indicate who manages the resource
  }

  # Lifecycle management to prevent accidental deletion
  lifecycle {
    prevent_destroy = true                          # Prevent deletion of the storage account
    ignore_changes  = [tags]                        # Ignore tag updates to prevent Terraform conflicts
  }
}

# Azure Monitor diagnostic settings for the storage account
resource "azurerm_monitor_diagnostic_setting" "state_storage" {
  # Enable diagnostic logging for security and compliance monitoring
  name                       = "state-storage-diagnostics"
  target_resource_id         = azurerm_storage_account.state.id
  log_analytics_workspace_id = var.log_analytics_workspace_id # Reference to the Azure Log Analytics workspace

  # Log read operations for auditing and analysis
  log {
    category = "StorageRead"
    enabled  = true
    retention_policy {
      days    = 30                                 # Retain logs for 30 days
      enabled = true
    }
  }

  # Log write operations for auditing and analysis
  log {
    category = "StorageWrite"
    enabled  = true
    retention_policy {
      days    = 30                                 # Retain logs for 30 days
      enabled = true
    }
  }
}