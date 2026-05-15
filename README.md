# aap-config-migration
## Using the bash scripts within a container:
### Create a temporary container and mount a volume for the "/aap_exports" folder:
```
podman run --rm -it --userns=keep-id -v /home/USER/exports:/aap_exports:Z,U aap-migration:latest
```

### Once inside the container, run the export/import scripts:
```
(app-root) /usr/bin/bash /opt/app-root/src/aap-config-migration/export_assets.sh
==========================================
  AAP Import Configuration
==========================================
Enter AAP Host URL [https://aap.example.com]: https://aap.example.com
Enter AAP Username [admin]:
Enter AAP Password:
Starting asset export from https://10.0.91.173...
------------------------------------------------
Exporting organizations... Done.
Exporting users... Done.
Exporting teams... Done.
Exporting credential_types... Done.
Exporting credentials... Done.
Exporting notification_templates... Done.
Exporting projects... Done.
Exporting inventories... Done.
Exporting inventory_sources... Done.
Exporting job_templates... Done.
Exporting workflow_job_templates... Done.
Exporting execution_environments... Done.
Exporting applications... Done.
------------------------------------------------
Export complete! All files are located in: /aap_exports/
```
