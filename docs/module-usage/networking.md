# Networking Module Usage Guide

## Overview
This module creates and manages the core networking infrastructure including Virtual Networks, subnets, and network security groups.

## Basic Usage
```hcl
module "networking" {
  source = "../../modules/networking"
  
  resource_group_name = "example-rg"
  environment        = "dev"
  location           = "eastus"
  
  subnet_configurations = {
    application = {
      address_prefix    = "10.0.1.0/24"
      service_endpoints = ["Microsoft.KeyVault"]
    }
    database = {
      address_prefix    = "10.0.2.0/24"
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}
```

## Required Variables
| Name | Description | Type | Required |
|------|-------------|------|----------|
| resource_group_name | Name of the resource group | string | Yes |
| environment | Environment (dev/staging/prod) | string | Yes |
| location | Azure region | string | Yes |
| subnet_configurations | Subnet configurations | map | Yes |

## Outputs
- `vnet_id`: Virtual Network ID
- `subnet_ids`: Map of subnet names to their IDs
- `nsg_ids`: Map of NSG names to their IDs