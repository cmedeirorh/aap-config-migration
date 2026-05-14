#!/bin/bash

# ==========================================
# AAP / AWX Asset Import Script (With Logging)
# ==========================================

# Connection Configuration
AWX_HOST="https://aap.example.com"
AWX_USER="admin"
AWX_PASS="PASS" 
INPUT_DIR="./aap_exports"
LOG_FILE="./aap_import.log"

# The strict dependency order for importing assets
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

# Initialize the log file with a timestamp
echo "=== AAP Import Log : $(date) ===" > "${LOG_FILE}"

echo "Starting asset import to ${AWX_HOST}..."
echo "Reading files from ${INPUT_DIR}/"
echo "Verbose logs are being written to: ${LOG_FILE}"
echo "------------------------------------------------"

# Loop through each asset type in the required dependency order
for item in "${IMPORT_ORDER[@]}"; do
    FILE_PATH="${INPUT_DIR}/${item}.json"
    
    # Check if the exported JSON file actually exists
    if [ -f "${FILE_PATH}" ]; then
        echo -n "Importing ${item}... "
        
        # Add a header to the log file for this specific asset
        echo "----------------------------------------" >> "${LOG_FILE}"
        echo "Attempting to import: ${item}" >> "${LOG_FILE}"
        echo "----------------------------------------" >> "${LOG_FILE}"
        
        # Execute the import and append both stdout and stderr to the log file
        AWXKIT_API_BASE_PATH='/api/controller/'; awx import \
            --conf.host "${AWX_HOST}" \
            --conf.user "${AWX_USER}" \
            --conf.password "${AWX_PASS}" \
            -k < "${FILE_PATH}" >> "${LOG_FILE}" 2>&1
            
        # Check the exit status of the awx command
        if [ $? -eq 0 ]; then
            echo "Success."
        else
            echo "Failed! (Check ${LOG_FILE} for details)"
        fi
        
        # Add a newline in the log file for readability
        echo -e "\n" >> "${LOG_FILE}"
    else
        echo "Skipping ${item}... (File ${FILE_PATH} not found)"
        echo "Skipped ${item}: File ${FILE_PATH} not found." >> "${LOG_FILE}"
    fi
done

echo "------------------------------------------------"
echo "Import sequence finished! Check ${LOG_FILE} for full output."
