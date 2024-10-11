#!/bin/bash
mapfile -t resource_group < <(az group list | jq -r .[].id)
for i in "${resource_group[@]}"; do
    az role assignment create --assignee-object-id "" --role "" --scope "${i}" --assignee-principal-type "Group"
done