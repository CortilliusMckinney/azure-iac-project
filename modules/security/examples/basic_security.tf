# examples/basic_security.tf
module "security" {
  source = "../"

  resource_group_name = "example-rg"
  environment         = "dev"
  location            = "eastus"
  key_vault_name      = "example-keyvault"

  network_acls = {
    default_action = "Deny"
    ip_rules       = ["123.123.123.123"]
    bypass         = ["AzureServices"]
  }
}
