# backend.tf
# This tells Terraform where to store information about our staging infrastructure.
# We use a different state file than development to keep environments isolated.
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatel9wa1akm"
    container_name       = "tfstate"

    # Note how we use 'staging' in the key name to separate it from other environments
    key = "staging.terraform.tfstate"
  }
}
