# Azure Security Module

## Overview

This module implements core security controls for Azure infrastructure,
providing centralized security management through Key Vault and robust access controls.

<!-- Explains the high-level purpose of the module -->

## Core Components

- **Azure Key Vault**: For secure secret management
- **Network Security Group configurations**: To enforce network traffic rules
- **Role-based access control (RBAC)**: For fine-grained permissions
- **Security monitoring and logging**: To detect and respond to security events
<!-- Lists the primary functionalities included in this module -->

## Module Features

1. **Key Vault Management**
   - Secure secret storage
   - Access policy configuration
   - Encryption key management
   - Certificate management
   <!-- Details the Key Vault features for secret and key handling -->
2. **Network Security**
   - Network access controls
   - Service endpoints
   - Private endpoints (optional)
   <!-- Describes network security capabilities for access control -->
3. **Access Control**
   - RBAC assignments
   - Managed identities
   - Access policies
   <!-- Highlights RBAC and identity management features -->

## Usage Example

```hcl
module "security" {
  source              = "./modules/security"

  resource_group_name = "terraform-state-rg"   # Name of the resource group
  environment         = "dev"            # Environment name for tagging
  location           = "eastus"          # Azure region for deployment
  key_vault_name     = "my-keyvault"     # Name of the Key Vault

  network_acls = {                        # Configure Network ACLs
    default_action = "Deny"               # Default action for unlisted IPs
    ip_rules       = ["123.123.123.123"]  # Allowed IP addresses
    bypass         = ["AzureServices"]   # Services that bypass ACL rules
  }
}
```
