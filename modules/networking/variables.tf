# variables.tf defines all input variables the networking module accepts.
# Each variable includes a description, type, and optional default value.

variable "resource_group_name" {
  description = "Name of the resource group where networking resources will be created"
  type        = string
}
variable "location" {
  description = "Azure region where the networking resources will be created"
  type        = string
}
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}
variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"] # Provides 65,536 addresses
}
variable "subnet_configurations" {
  description = "Map of subnet configurations"
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string), [])
  }))
}
