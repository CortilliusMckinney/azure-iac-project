# Azure Compute Module

## Overview

This module creates and manages virtual machines (servers) in Azure. It creates the computers that will run your applications.

## Core Components

- Virtual Machine creation and configuration
- Operating system disk management
- Network interface connections
- Basic monitoring setup

## Module Features

1. Virtual Machine Resources
   - Size optimization per environment
   - Operating system configuration
   - Network connectivity
2. Resource Management
   - Automated deployment
   - Environment-based configuration
   - Resource tagging

## Usage Example

```hcl
module "compute" {
  source = "./modules/compute"

  resource_group_name = "project-rg"
  environment        = "dev"
  location           = "eastus"

  vm_config = {
    name           = "appserver"
    size           = "Standard_B2s"
    admin_username = "adminuser"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
  }
  network_interface_id = module.networking.subnet_id
}
```

## Requirements

- Azure Provider >= 3.0
- Terraform >= 1.0
- Networking module must be deployed first
