# CI/CD Workflow Documentation

## Overview
Our infrastructure deployment follows a strict CI/CD process to ensure quality and safety. The pipeline automatically validates, plans, and applies infrastructure changes using GitHub Actions, supporting both automated and manual testing approaches.

## Testing Approaches

### 1. Automated Testing
Uses our Python testing framework to perform:
- Automated environment validation
- Security compliance checks
- Resource configuration verification
- Performance testing

### 2. Manual Testing
For teams not using the automated framework:
- Manual validation steps
- Direct Azure resource checks
- Security verification through Azure CLI
- Configuration validation

## Pipeline Stages

### 1. Validation Stage
The first stage checks infrastructure quality based on your chosen testing approach:

#### Automated Validation:
- Runs Python testing framework
- Executes environment-specific tests
- Performs comprehensive security checks
- Validates resource configurations

#### Manual Validation:
- Format verification using `terraform fmt`
- Configuration validation with `terraform validate`
- Azure resource security checks
- Network and Key Vault verification

### 2. Planning Stage
Creates and verifies infrastructure changes:
- Runs on pull requests only
- Creates detailed change plan
- Posts plan as PR comment for review
- Enables team review before deployment

### 3. Application Stage
Implements approved changes:
- Runs only on main branch
- Requires successful validation and planning
- Applies infrastructure changes
- Updates state management

## Security Configuration

### Required GitHub Secrets
```plaintext
AZURE_CLIENT_ID         # Service Principal ID
AZURE_CLIENT_SECRET     # Service Principal Secret
AZURE_SUBSCRIPTION_ID   # Azure Subscription ID
AZURE_TENANT_ID        # Azure AD Tenant ID