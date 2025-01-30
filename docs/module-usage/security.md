# Security Module Usage Guide

## Overview
This module manages security resources including Key Vault and security policies.

## Basic Usage
```hcl
module "security" {
  source = "../../modules/security"
  
  resource_group_name = "example-rg"
  environment        = "dev"
  location           = "eastus"
  key_vault_name     = "example-kv"
  
  network_acls = {
    default_action = "Deny"
    ip_rules       = ["123.123.123.123"]
    bypass         = ["AzureServices"]
  }
}
```

## Required Variables
| Name | Description | Type | Required |
|------|-------------|------|----------|
| resource_group_name | Name of the resource group | string | Yes |
| environment | Environment name | string | Yes |
| location | Azure region | string | Yes |
| key_vault_name | Name of the Key Vault | string | Yes |

## Outputs
- `key_vault_id`: Key Vault resource ID
- `key_vault_uri`: Key Vault URI