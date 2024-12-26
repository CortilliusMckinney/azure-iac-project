#!/bin/bash

# Color codes for better visibility
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
TFVARS_FILE="terraform.tfvars"
BACKUP_SUFFIX=".backup"

# Function to get current public IP - this is the IP address that Azure sees
# regardless of which tool (VS Code, Azure CLI, etc.) you're using
get_public_ip() {
    curl -s https://api.ipify.org
}

# Function to create terraform.tfvars if it doesn't exist
create_tfvars_template() {
    if [[ ! -f "$TFVARS_FILE" ]]; then
        echo -e "${BLUE}Creating new terraform.tfvars file...${NC}"
        cat > "$TFVARS_FILE" << EOL
# Environment settings
environment = "dev"
location    = "eastus"

# IP Ranges for access control
allowed_ip_ranges = [
]
EOL
    fi
}

# Function to backup terraform.tfvars
backup_tfvars() {
    if [[ -f "$TFVARS_FILE" ]]; then
        echo -e "${BLUE}Creating backup of terraform.tfvars...${NC}"
        cp "$TFVARS_FILE" "$TFVARS_FILE$BACKUP_SUFFIX"
    fi
}

# Function to update terraform.tfvars with new IP configurations
update_tfvars() {
    local current_ip=$(get_public_ip)
    echo -e "${BLUE}Your current public IP is: ${GREEN}$current_ip${NC}"
    
    # Create backup
    backup_tfvars
    
    # Create new content
    echo -e "${BLUE}Updating terraform.tfvars with new IP configurations...${NC}"
    
    cat > "$TFVARS_FILE" << EOL
# Environment settings
environment = "dev"
location    = "eastus"

# IP Ranges for access control
allowed_ip_ranges = [
    # GitHub Actions IP ranges (required for CI/CD)
    "20.37.158.0/23",    # GitHub Actions range
    "20.37.194.0/24",    # GitHub Actions range
    "20.38.34.0/23",     # GitHub Actions range
    
    # Your development IP (automatically updated)
    "$current_ip",       # Your current public IP
]

# Azure Subscription
subscription_id = "26fa681b-266b-4a85-b7f0-d0b40312d4e0"

# Resource Group Name
resource_group_name = "terraform-state-rg"

# Storage Account Prefix
storage_account_prefix = "tfstate"
EOL
    
    echo -e "${GREEN}Successfully updated terraform.tfvars!${NC}"
}

# Function to verify terraform.tfvars content
verify_tfvars() {
    echo -e "${BLUE}Verifying terraform.tfvars configuration...${NC}"
    
    if terraform fmt -check "$TFVARS_FILE" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Format check passed${NC}"
    else
        echo -e "${YELLOW}⚠ Formatting terraform.tfvars...${NC}"
        terraform fmt "$TFVARS_FILE"
    fi
    
    echo -e "${BLUE}Current IP configuration:${NC}"
    grep -A 10 "allowed_ip_ranges" "$TFVARS_FILE"
}

# Function to show IP status - simplified to show just your current public IP
show_ip_status() {
    local current_ip=$(get_public_ip)
    echo -e "${BLUE}IP Status:${NC}"
    echo -e "Your current public IP: ${GREEN}$current_ip${NC}"
    echo -e "\nThis is the IP address that Azure sees when you connect,"
    echo -e "regardless of which tool (VS Code, Azure CLI, etc.) you're using."
    echo ""
    echo -e "${BLUE}Configured IPs in terraform.tfvars:${NC}"
    verify_tfvars
}

# Main menu
main_menu() {
    while true; do
        echo -e "\n${BLUE}=== Terraform IP Configuration Manager ===${NC}"
        echo "1. Update terraform.tfvars with current IP"
        echo "2. Show IP status and configuration"
        echo "3. Verify terraform.tfvars format"
        echo "4. Exit"
        
        read -p "Choose an option (1-4): " choice
        
        case $choice in
            1)
                create_tfvars_template
                update_tfvars
                verify_tfvars
                ;;
            2)
                show_ip_status
                ;;
            3)
                verify_tfvars
                ;;
            4)
                echo -e "${GREEN}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
    done
}

# Run the script
main_menu