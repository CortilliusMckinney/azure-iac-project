# backend.tf

# Purpose: Configures where Terraform stores state information about your infrastructure.
# You'll need to replace the placeholder values below with your actual Azure resource names.
terraform {
  backend "azurerm" {
    # Replace <YOUR_STATE_RESOURCE_GROUP> with the name of your resource group
    # Example: "terraform-state-rg"
    resource_group_name = "terraform-state-rg"

    # Replace <YOUR_STORAGE_ACCOUNT_NAME> with your unique storage account name
    # Must be globally unique, lowercase, no special characters
    # Example: "tfstate123dev"
    storage_account_name = "tfstatel9wa1akm"

    # Replace <YOUR_CONTAINER_NAME> with your blob container name
    # Example: "tfstate"
    container_name = "tfstate"

    # Replace <YOUR_STATE_FILE_NAME> with your desired state file name
    # Example: "dev.terraform.tfstate"
    key = "dev.terraform.tfstate"
  }
}
