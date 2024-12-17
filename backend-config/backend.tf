# ------------------------------
# Backend State Configuration
# ------------------------------
terraform {
  backend "azurerm" {
    # Resource group containing the storage account (matches our backend-config)
    resource_group_name = "dev-tfstate-rg" # Matches ${var.environment}-tfstate-rg

    # Storage account details from backend setup
    storage_account_name = "<STORAGE_ACCOUNT_NAME>" # Will be dev-tfstate-[random_suffix]
    container_name       = "tfstate"                # Matches our container name

    # State file path within the container
    key = "dev/terraform.tfstate" # Organize by environment
  }
}
