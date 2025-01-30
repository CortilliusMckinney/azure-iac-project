# GitHub Secrets Configuration Guide

## Overview
This guide explains how to set up the required Azure authentication secrets in GitHub Actions. These secrets are essential for our CI/CD pipeline to securely deploy infrastructure to Azure.

## Required Secrets
You need to configure these four secrets in your GitHub repository:

### 1. AZURE_CLIENT_ID
- What: Your Azure service principal ID
- Where to find it: Azure AD App Registrations
- Purpose: Identifies your application to Azure

### 2. AZURE_CLIENT_SECRET
- What: Your service principal's secret key
- Where to find it: Azure AD App Registration's certificates & secrets
- Purpose: Authenticates your application

### 3. AZURE_SUBSCRIPTION_ID
- What: Your Azure subscription identifier
- Where to find it: Azure portal > Subscriptions
- Purpose: Identifies which subscription to deploy to

### 4. AZURE_TENANT_ID
- What: Your Azure AD tenant ID
- Where to find it: Azure AD > Properties
- Purpose: Identifies your Azure AD organization

## Configuration Steps

1. Navigate to GitHub Repository Settings
   - Open your repository
   - Click "Settings" tab
   - Select "Secrets and variables" > "Actions"

2. Add Each Secret
   - Click "New repository secret"
   - Enter the secret name exactly as shown above
   - Paste the corresponding value
   - Save the secret

## Additional Testing Secrets
Configure these secrets for comprehensive testing:

### TEST_AZURE_CREDENTIALS
- What: JSON credential object for testing
- Purpose: Enables test pipeline authentication
- Format:
  ```json
  {
    "clientId": "xxx",
    "clientSecret": "xxx",
    "subscriptionId": "xxx",
    "tenantId": "xxx"
  }

## Security Best Practices
- Never commit these values to your code
- Regularly rotate the client secret
- Use the minimum required permissions
- Monitor secret usage in GitHub Actions logs

## Verification
After adding all secrets:
1. Check they appear in Settings > Secrets
2. Verify names match exactly
3. Run a test GitHub Action to validate