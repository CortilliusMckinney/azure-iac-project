# variables.tf - Defines input variables for the storage module
variable "resource_group_name" {
  description = "Name of the resource group where the storage account will be created"
  type        = string
}
variable "location" {
  description = "Azure region where the storage account will be created"
  type        = string
  default     = "eastus"
}
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}
variable "storage_account_name" {
  description = "Name of the Azure Storage Account"
  type        = string
}
variable "replication_type" {
  description = "The replication type for the storage account (LRS, GRS)"
  type        = string
  default     = "LRS"
}
variable "enable_https_only" {
  description = "Enable HTTPS traffic only"
  type        = bool
  default     = true
}
variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}
variable "allow_blob_public_access" {
  description = "Allow public access to blobs"
  type        = bool
  default     = false
}
