# environments/dev/test_variables.tf

# Reference the parent variables
module "environment_config" {
  source = "../"

  # Environment settings
  environment = "dev"
  location    = "eastus"

}

# Output the configuration for verification
output "environment_settings" {
  value = module.environment_config.environment["dev"]
}
