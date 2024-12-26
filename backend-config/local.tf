# ------------------------------
# Local Values for Backend Storage
# ------------------------------

# Define local values for commonly used resource attributes
locals {
  # Common tags applied to all resources
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Backend State Storage"
  }
}
