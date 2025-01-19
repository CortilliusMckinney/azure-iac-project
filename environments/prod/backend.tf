terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatel9wa1akm"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate" # Production state file
    subscription_id      = "26fa681b-266b-4a85-b7f0-d0b40312d4e0"
  }
}
