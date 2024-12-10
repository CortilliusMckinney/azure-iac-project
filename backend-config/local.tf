# backend-config/local.tf

locals {
  # Resource naming conventions
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstate${random_string.suffix.result}"

  # Common tags that will be applied to all resources
  common_tags = {
    Environment      = "Management"
    Purpose          = "Terraform State"
    ManagedBy        = "DevOps"
    CriticalityLevel = "High"
    DataClass        = "Sensitive"
    LastUpdated      = formatdate("YYYY-MM-DD", timestamp())
    CostCenter       = "Infrastructure"
  }
}
