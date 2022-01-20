# Tools to refresh SPDX license list

## Update //licenses/spdx

This pulls in the authoritative list of licenses from the SPDX project
and updates our copy of it to include any new license identifiers.

It does not attempt to classify them in any way.

NOTE: You must run this from //admin/refresh_spdx

1.  Fetch the license list from the SPDX project.

    ```bash
    wget https://github.com/spdx/license-list-data/raw/master/json/licenses.json
    ```

1.  Run the refresh tool
    python add_licenses.py

