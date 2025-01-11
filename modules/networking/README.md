# Azure Networking Module

## Overview

This module implements a secure and scalable networking foundation for Azure resources. It creates a complete networking infrastructure with proper isolation and security controls.

## Core Features

- Virtual Network with customizable address space
- Subnet segmentation for different workloads
- Automated Network Security Group creation and association
- Service endpoint support for secure Azure service access
- Consistent resource naming with environment prefixes

## Module Components

1. Resource Group
   - Dedicated resource group for networking components
   - Environment-based naming convention
   - Proper resource tagging
2. Virtual Network
   - Configurable address space
   - Environment-specific deployment
   - Tag-based resource management
3. Subnets
   - Dynamic subnet creation based on configuration
   - Service endpoint support
   - Private link endpoint policy enforcement
4. Network Security Groups
   - One NSG per subnet
   - Default deny-all rule for enhanced security
   - Automatic subnet association

## Usage

```hcl
module "network" {
  source = "./modules/networking"

  resource_group_name = "project-rg"
  environment        = "dev"
  location           = "eastus"

  subnet_configurations = {
    application = {
      address_prefix    = "10.0.1.0/24"
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
    database = {
      address_prefix    = "10.0.2.0/24"
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}
```

## Requirements

- Azure Provider >= 3.0
- Terraform >= 1.0

## Inputs

| Name                  | Description                    | Type         | Required |
| --------------------- | ------------------------------ | ------------ | -------- |
| resource_group_name   | Name of the resource group     | string       | Yes      |
| location              | Azure region for deployment    | string       | Yes      |
| environment           | Environment (dev/staging/prod) | string       | Yes      |
| address_space         | VNet address space             | list(string) | No       |
| subnet_configurations | Subnet configurations map      | map(object)  | Yes      |

## Outputs

| Name       | Description                |
| ---------- | -------------------------- |
| vnet_id    | Virtual Network ID         |
| vnet_name  | Virtual Network name       |
| subnet_ids | Map of subnet names to IDs |
| nsg_ids    | Map of NSG names to IDs    |

## Security Features

- NSGs automatically created and associated with each subnet
- Default deny-all rule for inbound traffic
- Service endpoint support for secure Azure service access
- Private link endpoint policies enabled by default
