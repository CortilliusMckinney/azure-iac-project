#!/bin/bash
echo "Setting up Bootstrap Resources..."

# Variables
RESOURCE_GROUP_NAME="terraform-state-rg"
LOCATION="eastus"

# Check if logged in to Azure
if ! az account show > /dev/null 2>&1; then
    echo "Not logged into Azure CLI. Please run 'az login' and re-run the script."
    exit 1
fi

# Create Resource Group with Tags
if az group create \
    --name $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --tags Environment=Management \
          Project=Terraform \
          Purpose=State-Storage \
          ManagedBy=DevOps \
          CostCenter=Infrastructure; then
    echo "Resource Group Created: $RESOURCE_GROUP_NAME"
else
    echo "Failed to create Resource Group: $RESOURCE_GROUP_NAME"
    exit 1
fi