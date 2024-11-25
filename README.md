
# Azure Infrastructure as Code (IaC) Project

## 📋 Overview
This project implements Infrastructure as Code (IaC) for Azure cloud resources using Terraform. It provides a structured, modular approach to managing cloud infrastructure through code.

## 🏗️ Architecture
- `modules/` - Reusable infrastructure components
- `environments/` - Environment-specific configurations (dev, staging, prod)
- `scripts/` - Utility scripts and tools

---

## 🚀 Getting Started

### Prerequisites
- Azure CLI
- Terraform
- Git

---

### 🚀 Bootstrap Setup (Required First)

#### 💡 Understanding Bootstrap Resources
Before implementing our infrastructure with Terraform, we need to create foundational resources that will store the Terraform state. These are called "bootstrap" or "foundation" resources and are created once, either manually or via script.

#### 🤔 Why Manual Bootstrap?
- State storage must exist before Terraform can store state.
- These resources are created once and rarely changed.
- They form the foundation that enables Terraform to work.

---

#### 🛠️ Implementation Options

1. **⭐ Scripted Approach (Recommended):**
   ```bash
   #!/bin/bash
   echo "Setting up Bootstrap Resources..."

   # Variables
   RESOURCE_GROUP_NAME="terraform-state-rg"
   LOCATION="eastus"
   STORAGE_ACCOUNT_NAME="tfstate$(openssl rand -hex 4)"
   CONTAINER_NAME="tfstate"

   # Create Resource Group
   echo "Creating Resource Group..."
   az group create \
       --name $RESOURCE_GROUP_NAME \
       --location $LOCATION \
       --tags Environment=Management Project=Terraform Purpose=State-Storage

   # Create Storage Account
   echo "Creating Storage Account..."
   az storage account create \
       --resource-group $RESOURCE_GROUP_NAME \
       --name $STORAGE_ACCOUNT_NAME \
       --sku Standard_LRS \
       --encryption-services blob \
       --https-only true \
       --min-tls-version TLS1_2 \
       --allow-blob-public-access false \
       --tags Environment=Management Project=Terraform Purpose=State-Storage

   # Retrieve Storage Account Key
   ACCOUNT_KEY=$(az storage account keys list \
       --resource-group $RESOURCE_GROUP_NAME \
       --account-name $STORAGE_ACCOUNT_NAME \
       --query '[0].value' -o tsv)

   # Create Container
   echo "Creating Storage Container..."
   az storage container create \
       --name $CONTAINER_NAME \
       --account-name $STORAGE_ACCOUNT_NAME \
       --account-key $ACCOUNT_KEY

   echo "Bootstrap Complete!"
   echo "Resource Group: $RESOURCE_GROUP_NAME"
   echo "Storage Account: $STORAGE_ACCOUNT_NAME"
   echo "Container: $CONTAINER_NAME"
   ```

2. **🖥️ Azure Portal Approach (Alternative):**
   - Navigate to **Resource Groups** and click **+ Create**.
     - Name: `terraform-state-rg`
     - Region: Closest to your resources.
     - Tags: Add tags like Environment, Project, etc.
   - Navigate to **Storage Accounts** and click **+ Create**.
     - Use the same Resource Group.
     - Storage Account Name: Unique name (e.g., `tfstate[unique-suffix]`).
     - Enable secure transfer, encryption, and TLS 1.2+.
   - In **Containers**, create a container named `tfstate`.

3. **☁️ Azure CloudShell Approach:**
   ```bash
   curl -o bootstrap.sh https://raw.githubusercontent.com/YOUR-REPO/azure-iac-project/main/scripts/bootstrap.sh
   chmod +x bootstrap.sh
   ./bootstrap.sh
   ```

---

### ✅ Verification Steps:
After running the script or using the portal:
```bash
# Verify Resource Group
az group show --name $RESOURCE_GROUP_NAME

# Verify Storage Account
az storage account show \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $STORAGE_ACCOUNT_NAME

# Verify Container
az storage container exists \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $ACCOUNT_KEY
```

---

### 🔒 Security Notes:
- Store state access keys securely (e.g., in Azure Key Vault).
- Use RBAC roles for granular permissions.
- Enable diagnostics and logging for all storage accounts.

---

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/azure-iac-project.git
   cd azure-iac-project
   ```

2. Configure Azure credentials:
   ```bash
   az login
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

---

## 🔧 Usage
1. Select your environment:
   ```bash
   cd environments/dev  # or staging, prod
   ```

2. Review the configuration:
   ```bash
   terraform plan
   ```

3. Apply changes:
   ```bash
   terraform apply
   ```

---

## 🏗️ Infrastructure Components
- Resource Groups
- Virtual Networks
- Security Groups
- Storage Accounts
- Key Vault Integration

---

## 🔒 Security Notes
- Sensitive values are stored in Azure Key Vault.
- State files are stored in Azure Storage.
- Access control is managed through Azure RBAC.
- All secrets are encrypted at rest.

---

## 📚 Documentation
- Module documentation is available in each module directory.
- Environment-specific documentation is in respective environment folders.
- Additional documentation can be found in the `docs/` directory.

---

## 🤝 Contributing
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔍 Version Control
- All infrastructure changes are version controlled.
- Follow semantic versioning for releases.
- Each environment has its own state file.

---

## ⚡ CI/CD Pipeline
- Automated testing through GitHub Actions.
- Infrastructure validation on PR.
- Automated deployment to dev environment.
- Manual approval required for production deployments.

---

## 📊 Monitoring
- Azure Monitor integration.
- Resource health tracking.
- Cost management.
- Performance metrics.

---

## ✍️ Authors
* Cortillius Mckinney- *Initial work*

---

## 💡 Acknowledgments
* HashiCorp Terraform documentation.
* Azure Cloud documentation.
* Infrastructure as Code best practices.
