#!/bin/bash
# Script to create a Resource Group in Azure with appropriate tags

echo "Setting up Bootstrap Resources..."

# Variables
RESOURCE_GROUP_NAME="terraform-state-rg"
LOCATION="eastus"

# Step 1: Check if logged into Azure
echo "Checking Azure CLI login status..."
if ! az account show > /dev/null 2>&1; then
    echo "Error: Not logged into Azure CLI."
    echo "Please run 'az login' to authenticate and re-run the script."
    exit 1
fi
echo "Azure CLI login verified."

# Step 2: Create Resource Group with Tags
echo "Creating Resource Group: $RESOURCE_GROUP_NAME in location: $LOCATION..."
if az group create \
    --name $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --tags Environment=Management \
          Project=Terraform \
          Purpose=State-Storage \
          ManagedBy=DevOps \
          CostCenter=Infrastructure; then
    echo "Success: Resource Group '$RESOURCE_GROUP_NAME' created."
else
    echo "Error: Failed to create Resource Group '$RESOURCE_GROUP_NAME'."
    exit 1
fi