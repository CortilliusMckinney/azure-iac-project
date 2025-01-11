# Azure Storage Module

## Overview

This module creates and manages Azure Storage Accounts for securely storing application data.

## Core Components

- Storage Account configuration
- Security settings
- Access control management
- Data redundancy options

## Module Features

1. Storage Resources
   - Azure Storage Account creation
   - Blob storage configuration
   - Security settings
2. Resource Management
   - Environment-based setup
   - Resource tagging
   - Access control

## Usage Example

```hcl
module "storage" {
  source              = "./modules/storage"

  resource_group_name = "project-rg"
  environment        = "dev"
  location           = "eastus"
  storage_account_name = "myprojectstorage"
  replication_type    = "LRS"
}
```

## Requirements

- Azure Provider >= 3.0
- Terraform >= 1.0
