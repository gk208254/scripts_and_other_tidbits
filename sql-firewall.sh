#!/bin/bash
resource_group="${1}"
server="${2}"
#rulename=()
#start=()
#end=()
mapfile -t rulename < <(tail -n +2 parameters.csv | cut -d ',' -f 1)
mapfile -t start < <(tail -n +2 parameters.csv | cut -d ',' -f 2)
mapfile -t end < <(tail -n +2 parameters.csv | cut -d ',' -f 3)
for i in "${!rulename[@]}"; do
    printf '%s\t%s\t%s' "${rulename[i]}" "${start[i]}" "${end[i]}" 
    az sql server firewall-rule create --name "${rulename[i]}" --resource-group "${resource_group}" --server "${server}" --start-ip-address "${start[i]}" --end-ip-address "${end[i]}"
done