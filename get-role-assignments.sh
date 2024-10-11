#!/bin/bash
sub=''
#role_name=""
result=$(az role assignment list --scope "/subscriptions/${sub}")
echo "PrincipalName,PrincipalID,PrincipalType,Scope,RoleDefinition,RoleID" > details.txt
echo "PrincipalName,PrincipalID,PrincipalType,Scope,RoleDefinition,RoleID" > details2.txt
num=$(az role assignment list --scope "/subscriptions/${sub}" | jq -r ' . | length ')
for (( i=0; i < num; i++ )); do
    a=$(echo "${result}" | jq -r .[${i}].principalName)
    b=$(echo "${result}" | jq -r .[${i}].principalId)
    c=$(echo "${result}" | jq -r .[${i}].principalType)
    d=$(echo "${result}" | jq -r .[${i}].scope)
    e=$(echo "${result}" | jq -r .[${i}].roleDefinitionName)
    f=$(echo "${result}" | jq -r .[${i}].roleDefinitionId)
    echo "${a},${b},${c},${d},${e},${f}" >> details.txt
    if [[ "${e}" =~ ^(Owner|Contributor|Network Contributor)$ ]]; then
    echo "${a},${b},${c},${d},${e},${f}" >> details2.txt
    #    az role assignment create --assignee-object-id "${b}" \
    #                              --role "${role_name}" \
    #                              --scope "/subscriptions/${sub}" \
    #                              --assignee-principal-type "${c}"
    # add command to delete the role assignment
    # have to validate                              
    #    az role assignment delete --assignee "${b}" --role "${e}" --scope "/subscriptions/${sub}"
    fi    
done