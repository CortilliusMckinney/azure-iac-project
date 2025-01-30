# backend.tf
# Configuration for storing Terraform state in Azure Storage
# State files are isolated per environment for safety and management

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatel9wa1akm"
    container_name       = "tfstate"
    key                  = "staging.terraform.tfstate"

    # The backend will automatically use the following environment variables:
    # ARM_CLIENT_ID
    # ARM_CLIENT_SECRET
    # ARM_TENANT_ID
    # ARM_SUBSCRIPTION_ID

    # No need to specify authentication details here as they come from environment variables
  }
}
