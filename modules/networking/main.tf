# Required providers block specifies which providers this module needs
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Resource group dedicated to networking resources
resource "azurerm_resource_group" "networking" {
  name     = "${var.environment}-${var.resource_group_name}-networking"
  location = var.location

  tags = {
    Environment = var.environment
    Purpose     = "Networking"
    ManagedBy   = "Terraform"
  }
}

# Virtual Network - the foundation of our network infrastructure
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-vnet"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  address_space       = var.address_space

  tags = {
    Environment = var.environment
    Purpose     = "Core Networking"
    ManagedBy   = "Terraform"
  }
}

# Subnets - separate network segments for different purposes
resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_configurations

  name                 = "${var.environment}-${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints
}

# Network Security Groups - like firewalls for our subnets
resource "azurerm_network_security_group" "subnet_nsgs" {
  for_each = var.subnet_configurations

  name                = "${var.environment}-${each.key}-nsg"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    Environment = var.environment
    Purpose     = "Network Security"
    Subnet      = each.key
  }
}
# Associate NSGs with their corresponding subnets
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_associations" {
  for_each                  = var.subnet_configurations
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.subnet_nsgs[each.key].id
}
