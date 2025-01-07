#!/bin/bash

# Script to validate, plan, and apply Terraform configurations
# This script checks if there are any changes in the Terraform configuration
# and applies them if necessary.

# Step 1: Run Terraform Validation
# ---------------------------------
# Change to the parent directory where the Terraform configuration files are located.
# Ensure Terraform configuration files (.tf) are present and valid.
echo "Running Terraform Validation..."
cd ../
terraform validate

# Step 2: Run Terraform Plan
# --------------------------
# Generate an execution plan to check for changes without applying them.
# The output is saved to 'plan.out' for further inspection.
echo "Running Terraform Plan..."
terraform plan -var-file="terraform.tfvars" > plan.out

# Step 3: Check the Plan Output
# -----------------------------
# Look for the string "No changes. Infrastructure is up-to-date." in the plan output.
# If no changes are detected, print a message and skip the apply step.
# Otherwise, apply the changes automatically.
if grep -q "No changes. Infrastructure is up-to-date." plan.out; then
    echo "No changes detected. IP update did not affect the configuration."
else
    echo "Changes detected. Applying updates..."
    terraform apply -var-file="terraform.tfvars" -auto-approve
fi