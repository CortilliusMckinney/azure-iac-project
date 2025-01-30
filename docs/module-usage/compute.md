# Compute Module Usage Guide

## Overview
This module manages compute resources such as Virtual Machines and related components.

## Basic Usage
```hcl
module "compute" {
  source = "../../modules/compute"
  
  resource_group_name = "example-rg"
  environment        = "dev"
  location           = "eastus"
  
  vm_config = {
    name           = "example-vm"
    size           = "Standard_B2s"
    admin_username = "adminuser"
    
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
  }
}
```

## Required Variables
| Name | Description | Type | Required |
|------|-------------|------|----------|
| resource_group_name | Name of the resource group | string | Yes |
| environment | Environment name | string | Yes |
| location | Azure region | string | Yes |
| vm_config | VM configuration object | object | Yes |

## Outputs
- `vm_id`: Virtual Machine ID
- `vm_name`: Virtual Machine name