#!/bin/bash
sub="${1}"
az account set --subscription "${sub}"
echo "name,resourceGroup,diskState,timeCreated,LastOwnershipUpdateTime"
mapfile -t resource_group < <(az group list | jq -r '.[].name')
for rg in "${resource_group[@]}"; do
        mapfile -t disk_list < <(az disk list --resource-group "${rg}" | jq -r .[].name)
        for disk in "${disk_list[@]}"; do
			disk_json=$(az disk show --resource-group "${rg}" --name "${disk}")
            name=$(echo "${disk_json}" | jq -r .name)
            diskState=$(echo "${disk_json}" | jq -r .diskState)
            LastOwnershipUpdateTime=$(echo "${disk_json}" | jq -r .LastOwnershipUpdateTime)
            timeCreated=$(echo "${disk_json}" | jq -r .timeCreated)
            if [[ "${diskState}" == "Unattached" ]]; then
                echo "${name},${rg},${diskState},${timeCreated},${LastOwnershipUpdateTime}"
                # az disk delete --name "${name}" --resource-group "${rg}" --no-wait --yes
            fi
        done
done