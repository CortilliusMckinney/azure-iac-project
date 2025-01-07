#!/bin/bash

# Replace with your actual container name and storage account name:
CONTAINER_NAME="tfstate"
STORAGE_ACCOUNT_NAME="tfstatel9wa1akm"

echo "Verifying Azure Blob Storage Access for container '$CONTAINER_NAME'..."

# 1. Verify Azure Blob Access with Azure AD
az storage blob list \
  --container-name "tfstate" \
  --account-name "tfstatel9wa1akm" \
  --auth-mode login

if [ $? -ne 0 ]; then
  echo "ERROR: Unable to access Azure Storage container."
  echo "       Check your RBAC role, IP allowlists, or 'az login' session."
  exit 1
fi

echo "Blob storage access verified successfully!"

# 2. Initialize Terraform backend
echo "Initializing Terraform backend..."
terraform init -reconfigure

if [ $? -eq 0 ]; then
  echo "Terraform initialized successfully!"
else
  echo "ERROR: Terraform init failed."
  exit 1
fi