# providers.tf
# The provider configuration is consistent across environments to ensure
# reliable communication with Azure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Remove all credential configurations
  # The provider automatically reads from environment variables:
  # ARM_SUBSCRIPTION_ID
  # ARM_TENANT_ID
  # ARM_CLIENT_ID
  # ARM_CLIENT_SECRET
}

