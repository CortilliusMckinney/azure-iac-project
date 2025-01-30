# Storage Module Usage Guide

## Overview
This module manages Azure Storage resources including storage accounts and blob containers.

## Basic Usage
```hcl
module "storage" {
  source = "../../modules/storage"
  
  resource_group_name   = "example-rg"
  environment          = "dev"
  location             = "eastus"
  storage_account_name = "examplestorage"
  replication_type     = "LRS"
}
```

## Required Variables
| Name | Description | Type | Required |
|------|-------------|------|----------|
| resource_group_name | Name of the resource group | string | Yes |
| environment | Environment name | string | Yes |
| location | Azure region | string | Yes |
| storage_account_name | Storage account name | string | Yes |
| replication_type | Storage replication type | string | No |

## Outputs
- `storage_account_id`: Storage Account ID
- `storage_account_name`: Storage Account name
- `primary_blob_endpoint`: Primary blob storage endpoint