#!/bin/bash

# ==========================================
# AAP / AWX Asset Import Script
# ==========================================

# Connection Configuration
AWX_HOST="https://aap.example.com"
AWX_USER="admin"
AWX_PASS="PASS" # Consider passing this via an environment variable
INPUT_DIR="./aap_exports"

# The strict dependency order for importing assets. 
# Foundational elements (Orgs, Users) must be created before objects that rely on them (Projects, Templates).
IMPORT_ORDER=(
    "organizations"
    "users"
    "teams"
    "credential_types"
    "execution_environments"
    "credentials"
    "notification_templates"
    "projects"
    "inventories"
    "inventory_sources"
    "job_templates"
    "workflow_job_templates"
    "applications"
)

echo "Starting asset import to ${AWX_HOST}..."
echo "Reading files from ${INPUT_DIR}/"
echo "------------------------------------------------"

# Loop through each asset type in the required dependency order
for item in "${IMPORT_ORDER[@]}"; do
    FILE_PATH="${INPUT_DIR}/${item}.json"
    
    # Check if the exported JSON file actually exists before trying to import
    if [ -f "${FILE_PATH}" ]; then
        echo -n "Importing ${item}... "
        
        # Execute the import command feeding the JSON file via standard input
        awx import \
            --conf.host "${AWX_HOST}" \
            --conf.user "${AWX_USER}" \
            --conf.password "${AWX_PASS}" \
            -k < "${FILE_PATH}" > /dev/null 2>&1
            
        # Check the exit status of the awx command
        if [ $? -eq 0 ]; then
            echo "Success."
        else
            echo "Failed! (Check AAP logs or run manually without redirecting output to see the error)"
        fi
    else
        echo "Skipping ${item}... (File ${FILE_PATH} not found)"
    fi
done

echo "------------------------------------------------"
echo "Import sequence finished!"
