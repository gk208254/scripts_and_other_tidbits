#!/bin/bash
mapfile -t resource_group < <(az group list | jq -r '.[].name' | grep -iE '(GTTGZ|COBUN|ESOVD|MXMID|WEAZE)[0-9]*$') 
for rg in "${resource_group[@]}"; do
		mapfile -t vm_list < <(az vm list --resource-group "${rg}" | jq -r .[].name)
        for vm in "${vm_list[@]}"; do
			vm_json=$(az vm show --resource-group "${rg}" --name "${vm}" -d)
            VM_status=$(echo "${vm_json}" | jq -r '.powerState')
			VM_size=$(echo "${vm_json}" | jq -r '.hardwareProfile.vmSize')
			VM_datadisk=$(echo "${vm_json}" | jq -r '.storageProfile.dataDisks | length')
			image_id=$(echo "${vm_json}" | jq -r '.storageProfile.imageReference.id')
            image_id_short=$(basename "${image_id}")
			VM_OS=$(echo "${vm_json}" | jq -r '.storageProfile.osDisk.osType')
			echo "${vm}, ${VM_status}, ${VM_size}, ${VM_datadisk}, ${VM_OS}, ${image_id_short}"
        done
done
