# backend-config/variables.tf

# Define the Azure region where resources will be deployed.
# This variable sets the location for the resource group and other resources.
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus" # Default region is set to 'eastus'.
}

# Specify the list of IP ranges allowed to access the storage account.
# This helps implement network security by restricting access to trusted IPs only.
variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access the storage account"
  type        = list(string)
  default     = [] # Default is an empty list, meaning no IP restrictions are applied.
}

# Define the environment name to be used for resource tagging.
# This allows easy identification and grouping of resources across environments.
variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "Management" # Default environment name is set to 'Management'.
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace for diagnostic logging"
  type        = string
}
