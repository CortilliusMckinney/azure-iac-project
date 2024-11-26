```markdown
# Azure Infrastructure as Code (IaC) Project

## 📋 Overview
This project implements Infrastructure as Code (IaC) for Azure cloud resources using Terraform. It provides a structured, modular approach to managing cloud infrastructure through code.

## 🏗️ Architecture
- `modules/` - Reusable infrastructure components
- `environments/` - Environment-specific configurations (dev, staging, prod)
- `scripts/` - Utility scripts and tools

## 🚀 Getting Started

### Prerequisites
- Azure CLI
- Terraform
- Git
- Visual Studio Code

### Bootstrap Setup (Required First)

#### 💡 Understanding Bootstrap Resources
Before implementing our infrastructure with Terraform, we need to create foundation resources that will store the Terraform state. These are called "bootstrap" or "foundation" resources and are created once, either manually or via script.

#### 🤔 Why Manual Bootstrap?
- State storage must exist before Terraform can store state
- These resources are created once and rarely changed
- They form the foundation that enables Terraform to work

#### 🛠️ Implementation Using VS Code

1. **📂 Create Bootstrap Script:**
   - In VS Code, create new file: `scripts/bootstrap.sh`
   - Open Command Palette (Ctrl+Shift+P or Cmd+Shift+P)
   - Type: "new file"
   - Enter path: `scripts/bootstrap.sh`

2. **✍️ Add Script Content:**
   ```bash{.no-copy}
   #!/bin/bash

   # Set variables
   RESOURCE_GROUP_NAME="terraform-state-rg"
   LOCATION="eastus"
   STORAGE_ACCOUNT_NAME="tfstate$(openssl rand -hex 4)"
   CONTAINER_NAME="tfstate"

   # Create Resource Group
   echo "Creating Resource Group..."
   az group create \
       --name $RESOURCE_GROUP_NAME \
       --location $LOCATION \
       --tags Environment=Management \
             Project=Terraform \
             Purpose=State-Storage

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
       --tags Environment=Management \
             Project=Terraform \
             Purpose=State-Storage

   # Get Storage Account Key
   echo "Retrieving Storage Account Key..."
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

   # Output important information
   echo "Bootstrap Complete! Please save these details:"
   echo "Resource Group: $RESOURCE_GROUP_NAME"
   echo "Storage Account: $STORAGE_ACCOUNT_NAME"
   echo "Container: $CONTAINER_NAME"
   ```

3. **▶️ Execute Script:**
   - Open VS Code integrated terminal (Ctrl+` or Cmd+`)
   - Navigate to scripts directory:
   ```bash{.no-copy}
   $ cd scripts
   $ chmod +x bootstrap.sh
   $ ./bootstrap.sh
   ```

4. **💾 Save Script Output:**
   - Create new file: `scripts/terraform.env`
   - Store the output values (they'll be needed for backend configuration)
   ```bash{.no-copy}
   RESOURCE_GROUP_NAME=terraform-state-rg
   STORAGE_ACCOUNT_NAME=<your-storage-account-name>
   CONTAINER_NAME=tfstate
   ```

#### ✅ Verification in VS Code

1. **📋 Install Azure Extension:**
   - Open VS Code Extensions (Ctrl+Shift+X or Cmd+Shift+X)
   - Search for "Azure"
   - Install "Azure Account" and "Azure Resources"

2. **🔍 Verify Resources:**
   - Open Azure extension
   - Navigate to Resource Groups
   - Verify `terraform-state-rg` exists
   - Check Storage Account properties

3. **🧪 Test Configuration:**
   ```bash{.no-copy}
   # In VS Code terminal
   $ az group show --name $RESOURCE_GROUP_NAME
   ```

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

## 🏗️ Infrastructure Components
- Resource Groups
- Virtual Networks
- Security Groups
- Storage Accounts
- Key Vault Integration

## 🔒 Security Notes
- Sensitive values are stored in Azure Key Vault
- State files are stored in Azure Storage
- Access control is managed through Azure RBAC
- All secrets are encrypted at rest

## 📚 Documentation
- Module documentation is available in each module directory
- Environment-specific documentation is in respective environment folders
- Additional documentation can be found in the `docs/` directory

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 🔍 Version Control
- All infrastructure changes are version controlled
- Follow semantic versioning for releases
- Each environment has its own state file

## ⚡ CI/CD Pipeline
- Automated testing through GitHub Actions
- Infrastructure validation on PR
- Automated deployment to dev environment
- Manual approval required for production deployments

## 📊 Monitoring
- Azure Monitor integration
- Resource health tracking
- Cost management
- Performance metrics

## ✍️ Authors
* Your Name - *Initial work*

## 💡 Acknowledgments
* HashiCorp Terraform documentation
* Azure Cloud documentation
* Infrastructure as Code best practices
```