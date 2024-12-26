import subprocess


def run_az_command(command):
    """Run an Azure CLI command and return its output."""
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print(f"Error running command: {command}\n{result.stderr.decode('utf-8').strip()}")
        return None
    return result.stdout.decode('utf-8').strip()


def get_subscription_id():
    """Retrieve the Azure subscription ID."""
    return run_az_command('az account show --query id -o tsv')


def get_tenant_id():
    """Retrieve the Azure AD tenant ID."""
    return run_az_command('az account show --query tenantId -o tsv')


def get_resource_groups():
    """List available Azure resource groups."""
    output = run_az_command('az group list --query "[].name" -o tsv')
    if not output:
        print("No resource groups found. Please ensure you have permissions and resource groups in your subscription.")
        return []
    return output.split('\n')


def get_storage_accounts(resource_group=None):
    """Retrieve storage accounts within a resource group or the subscription."""
    if resource_group:
        command = f'az storage account list --resource-group {resource_group} --query "[].name" -o tsv'
    else:
        command = 'az storage account list --query "[].name" -o tsv'
    output = run_az_command(command)
    if not output:
        print("No storage accounts found. Please ensure you have permissions and storage accounts in your subscription.")
        return []
    return output.split('\n')


def get_storage_account_name(resource_group):
    """Prompt user to select a storage account."""
    print(f"Retrieving storage accounts in resource group: {resource_group}")
    storage_accounts = get_storage_accounts(resource_group)
    if not storage_accounts:
        print(f"No storage accounts found in resource group: {resource_group}.")
        return None
    print("Available storage accounts:")
    for i, sa in enumerate(storage_accounts, start=1):
        print(f"{i}. {sa}")
    account_index = int(input("Please enter the number of the storage account you want to use: "))
    return storage_accounts[account_index - 1]


def get_storage_account_prefix():
    """Retrieve the storage account prefix."""
    print("Retrieving storage account prefix...")
    return "tfstate"


def get_state_file_key():
    """Retrieve the key for the state file within the container."""
    return "dev"  # Hard-coded value for the state file key


# Main Logic
print("Azure Terraform Project Setup Helper\n")

subscription_id = get_subscription_id()
if subscription_id:
    print(f"Your Azure subscription ID is: {subscription_id}\n")
else:
    print("Failed to retrieve subscription ID. Please ensure Azure CLI is authenticated.")

tenant_id = get_tenant_id()
if tenant_id:
    print(f"Your Azure AD tenant ID is: {tenant_id}\n")
else:
    print("Failed to retrieve tenant ID. Please ensure Azure CLI is authenticated.")

print("Available resource groups:")
resource_groups = get_resource_groups()
if resource_groups:
    for i, rg in enumerate(resource_groups, start=1):
        print(f"{i}. {rg}")
    resource_group_index = int(input("Please enter the number of the resource group you want to use: "))
    resource_group = resource_groups[resource_group_index - 1]
else:
    resource_group = input("Please enter the name of the resource group manually: ")

storage_account_name = get_storage_account_name(resource_group)
if not storage_account_name:
    storage_account_name = input("No storage account found. Please enter the storage account name manually: ")

storage_account_prefix = get_storage_account_prefix()
state_file_key = get_state_file_key()

print("\nSummary of retrieved information:\n")
print(f"Subscription ID: {subscription_id}")
print(f"Tenant ID: {tenant_id}")
print(f"Resource Group: {resource_group}")
print(f"Storage Account Name: {storage_account_name}")
print(f"Storage Account Prefix: {storage_account_prefix}")
print(f"Path to State File (Key): {state_file_key}")