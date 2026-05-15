#!/bin/bash

# ==========================================
# AAP / AWX Asset Export Script
# ==========================================

# Connection Configuration
AWX_HOST="https://aap.example.com"
AWX_USER="admin"
AWX_PASS="PASS" # Note: For better security, consider passing this via an environment variable
OUTPUT_DIR="./aap_exports"

# List of standard AWX/AAP assets to export
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

echo "Starting asset export from ${AWX_HOST}..."
echo "------------------------------------------------"

# Loop through each asset type in the array
for item in "${ASSETS[@]}"; do
    echo -n "Exporting ${item}... "
    
    # Execute the export command
    awx export --${item} \
        --conf.host "${AWX_HOST}" \
        --conf.user "${AWX_USER}" \
        --conf.password "${AWX_PASS}" \
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
