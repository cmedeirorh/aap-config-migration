#!/bin/bash

echo "=========================================="
echo "  AAP Export Configuration"
echo "=========================================="

# Prompt for variables with defaults
read -p "Enter AAP Host URL [https://aap.example.com]: " AAP_HOST
AAP_HOST=${AAP_HOST:-https://aap.example.com}

read -p "Enter AAP Username [admin]: " AAP_USER
AAP_USER=${AAP_USER:-admin}

# Use -s to hide the password input
read -s -p "Enter AAP Password: " AAP_PASS
echo "" # Print a newline after silent input

# Fail fast if no password is provided
if [ -z "$AAP_PASS" ]; then
    echo "Error: Password cannot be empty. Exiting."
    exit 1
fi

OUTPUT_DIR="/aap_exports"

# List of standard AAP assets to export
# Add or remove items from this array as needed for your specific environment
ASSETS=(
    "organizations"
    "users"
    "teams"
    "credential_types"
    "credentials"
    "notification_templates"
    "projects"
    "inventories"
    "inventory_sources"
    "job_templates"
    "workflow_job_templates"
    "execution_environments"
    "applications"
)

# Create the output directory if it doesn't already exist
mkdir -p "${OUTPUT_DIR}"

echo "Starting asset export from ${AAP_HOST}..."
echo "------------------------------------------------"

# Loop through each asset type in the array
for item in "${ASSETS[@]}"; do
    echo -n "Exporting ${item}... "
    
    # Execute the export command
    awx export --${item} \
        --conf.host "${AAP_HOST}" \
        --conf.user "${AAP_USER}" \
        --conf.password "${AAP_PASS}" \
        -k > "${OUTPUT_DIR}/${item}.json" 2>/dev/null
        
    # Check the exit status of the awx command
    if [ $? -eq 0 ]; then
        echo "Done."
    else
        echo "Failed! (Check if the asset type exists in your AAP version)"
        # Optional: remove the empty/failed JSON file to keep the directory clean
        rm -f "${OUTPUT_DIR}/${item}.json"
    fi
done

echo "------------------------------------------------"
echo "Export complete! All files are located in: ${OUTPUT_DIR}/"
