#!/bin/bash
echo "Setting up Bootstrap Resources..."

# Variables
RESOURCE_GROUP_NAME="terraform-state-rg"
LOCATION="eastus"

# Check if the Resource Group already exists
if az group show --name $RESOURCE_GROUP_NAME > /dev/null 2>&1; then
    echo "Resource Group '$RESOURCE_GROUP_NAME' already exists!"
else
    echo "Creating Resource Group '$RESOURCE_GROUP_NAME'..."
    # Attempt to create the Resource Group
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
fi