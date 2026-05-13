Role Name
=========

A comprehensive Ansible role to export your configuration from AAP 2.4 and import it into AAP 2.6.

Role Variables
--------------

# Action to perform: 'export' or 'import'
aap_action: 'export'

# The path to store or read the exported JSON/YAML data
aap_export_file_path: "/tmp/aap_config_export.json"

# AAP Connection Variables (Override these at playbook runtime)
aap_host: ""
aap_username: ""
aap_password: ""
aap_validate_certs: false

# Export Settings
aap_export_all: true

Dependencies
------------

collections:
  - ansible.controller

Important Execution Notes
-------------------------

1 - Staged Execution: If your environments aren't able to reach each other directly from the executing node, you can comment out "Step 2", run the playbook to generate aap_backup.json, move the file, and then run a separate playbook for the import.

2 - Schema Changes: AAP 2.4 to 2.6 introduced minor schema additions (especially around Execution Environments). The ansible.controller.import module handles most backward compatibility transparently by ignoring unknown parameters.

3 - Execution Environments: Ensure the container registries and execution environments referenced in AAP 2.4 actually exist or are available to the AAP 2.6 cluster before you run the import, otherwise template imports that hard-reference custom EE images might fail or fall back to default behavior.

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
