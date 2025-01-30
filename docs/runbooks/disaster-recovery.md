# Disaster Recovery Procedures

## Overview
This document outlines the procedures for recovering infrastructure in case of failures or disasters.

## Recovery Scenarios

### 1. State File Loss/Corruption
Steps to recover:
1. Access backup state file from Azure Storage
```bash
az storage blob download \
    --container-name tfstate \
    --name terraform.tfstate \
    --account-name <storage-account-name> \
    --file terraform.tfstate.backup
```

2. Restore state file:
```bash
# Copy backup to active state
cp terraform.tfstate.backup terraform.tfstate
terraform init
```

### 2. Resource Group Failure
Steps to recover:
1. Import existing resources:
```bash
terraform import azurerm_resource_group.main /subscriptions/<subscription-id>/resourceGroups/<rg-name>
```

2. Re-apply configuration:
```bash
terraform plan
terraform apply
```

### 3. Network Connectivity Loss
Recovery steps:
1. Verify NSG rules
2. Check service endpoints
3. Validate DNS resolution
4. Re-apply network configuration if needed

### 4. Key Vault Access Issues
Steps to restore:
1. Check access policies
2. Verify network access
3. Restore deleted secrets if needed

## Recovery Time Objectives (RTO)
- State file recovery: < 1 hour
- Resource group recovery: < 2 hours
- Network recovery: < 1 hour
- Full infrastructure recovery: < 4 hours

## Recovery Point Objectives (RPO)
- State files: 24 hours
- Resource configurations: 1 hour
- Application data: Based on backup policy