#!/bin/bash

# This script manages Terraform IP configurations, updating terraform.tfvars with
# the current public IP and GitHub Actions IP ranges.

# Color codes for better visibility in terminal outputs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'  # No color

# Configuration
TFVARS_FILE="terraform.tfvars"         # The target Terraform variables file
BACKUP_SUFFIX=".backup"               # Suffix for backup files

# Function to get the current public IP address
# ---------------------------------------------
# Uses ipify API to fetch the public IP of the machine running the script.
get_public_ip() {
    curl -s https://api.ipify.org
}

# Function to fetch GitHub Actions IP ranges
# ------------------------------------------
# Retrieves GitHub Actions IP ranges using the GitHub Meta API.
# Filters the first three IP ranges for simplicity.
fetch_github_ips() {
    curl -s https://api.github.com/meta | jq -r '.actions[]' | head -3
}

# Function to back up terraform.tfvars
# ------------------------------------
# Creates a backup of the terraform.tfvars file before making updates.
backup_tfvars() {
    if [[ -f "$TFVARS_FILE" ]]; then
        echo -e "${BLUE}Creating backup of terraform.tfvars...${NC}"
        cp "$TFVARS_FILE" "$TFVARS_FILE$BACKUP_SUFFIX"
    fi
}

# Function to update allowed_ip_ranges in terraform.tfvars
# --------------------------------------------------------
# Updates or adds the allowed_ip_ranges section with the current public IP
# and GitHub Actions IP ranges.
update_tfvars() {
    local current_ip=$(get_public_ip)                # Fetch current public IP
    local github_ips=($(fetch_github_ips))          # Fetch GitHub IP ranges

    echo -e "${BLUE}Updating terraform.tfvars with current IP and GitHub IPs...${NC}"

    # Backup the original terraform.tfvars
    backup_tfvars

    # Parse and update the terraform.tfvars file while preserving other content
    awk -v current_ip="$current_ip/30" -v github_ip_1="${github_ips[0]}" -v github_ip_2="${github_ips[1]}" -v github_ip_3="${github_ips[2]}" '
    BEGIN { updating_ips = 0 }
    /allowed_ip_ranges = \[/ {
        print "allowed_ip_ranges = ["
        print "  \"" current_ip "\",   # Your development machine/office IP"
        print "  \"" github_ip_1 "\",     # GitHub Actions IP range for CI/CD"
        print "  \"" github_ip_2 "\",     # Additional GitHub Actions IPs"
        print "  \"" github_ip_3 "\"      # More GitHub Actions IPs"
        print "]"
        updating_ips = 1
        while (getline > 0) {
            if ($0 ~ /\]/) break
        }
        next
    }
    { print }  # Print all other lines as is
    END {
        # Add the allowed_ip_ranges section if it does not exist
        if (!updating_ips) {
            print "allowed_ip_ranges = ["
            print "  \"" current_ip "\",   # Your development machine/office IP"
            print "  \"" github_ip_1 "\",     # GitHub Actions IP range for CI/CD"
            print "  \"" github_ip_2 "\",     # Additional GitHub Actions IPs"
            print "  \"" github_ip_3 "\"      # More GitHub Actions IPs"
            print "]"
        }
    }
    ' "$TFVARS_FILE" > "${TFVARS_FILE}.tmp"

    # Replace the original file with the updated version
    mv "${TFVARS_FILE}.tmp" "$TFVARS_FILE"
    echo -e "${GREEN}Successfully updated terraform.tfvars!${NC}\n"
}

# Function to show the current allowed_ip_ranges in terraform.tfvars
# ------------------------------------------------------------------
# Displays the allowed IP ranges currently defined in the file.
show_ip_ranges() {
    echo -e "${BLUE}Current IP ranges in terraform.tfvars:${NC}\n"
    grep -A 10 "allowed_ip_ranges" "$TFVARS_FILE"
}

# Main menu function
# ------------------
# Provides an interactive menu for users to manage Terraform IP configurations.
main_menu() {
    while true; do
        echo -e "\n${BLUE}=== Terraform IP Configuration Manager ===${NC}"
        echo "1. Show IP ranges in terraform.tfvars"
        echo "2. Update terraform.tfvars with current IP and GitHub IPs"
        echo "3. Exit"
        read -p "Choose an option (1-3): " choice

        case $choice in
            1)
                show_ip_ranges
                ;;
            2)
                update_tfvars
                ;;
            3)
                echo -e "${GREEN}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                ;;
        esac
    done
}

# Execute the main menu
main_menu