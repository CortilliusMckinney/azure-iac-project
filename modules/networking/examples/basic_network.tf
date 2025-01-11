# examples/basic_network.tf
module "network" {
  source = "../" # Reference to parent module directory

  resource_group_name = "terraform-state-rg"
  environment         = "dev"
  location            = "eastus"

  subnet_configurations = {
    application = {
      address_prefix    = "10.0.1.0/24"
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
    database = {
      address_prefix    = "10.0.2.0/24"
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}
