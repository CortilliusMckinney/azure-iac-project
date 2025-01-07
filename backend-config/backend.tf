# ------------------------------
# Backend State Configuration
# ------------------------------
# Configure the backend storage with static values.

terraform {
  backend "azurerm" {
    # Replace with your actual resource group name
    resource_group_name = "terraform-state-rg"

    # Replace with your actual storage account name
    storage_account_name = "tfstatel9wa1akm"

    # Blob container name for Terraform state files
    container_name = "tfstate"

    # Default path to the state file within the container
    key = "dev/terraform.tfstate"
  }
}
