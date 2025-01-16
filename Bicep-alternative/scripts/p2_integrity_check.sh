#!/bin/bash

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --policyName) policyName="$2"; shift ;;
        --resourceGroupName) resourceGroupName="$2"; shift ;;
        --customRuleName) customRuleName="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

az extension add --name front-door --allow-preview true

csvPath="./allowed_ip_csv/${policyName}.csv"

echo "Starting synchronization for WAF policy: ${policyName}"

# Fetch current IPs from WAF policy
currentIPs=$(az network front-door waf-policy rule list --resource-group ${resourceGroupName} --policy-name ${policyName} --query "[?name=='${customRuleName}'].matchConditions[0].matchValue[]" -o tsv | tr '\n' ' ' | tr -d '\r')
echo -e "\n\n########################################"
echo "##### Currently Configured IPs #########"
echo "########################################"
echo "$currentIPs" | tr ' ' '\n'

mapfile -t csvLines < <(awk -F',' '{print $1","$2}' ${csvPath})


echo -e "\n\n########################################"
echo "##### Expected IPs and Customers #######"
echo "########################################"
# Check if the CSV file is empty
if [ ${#csvLines[@]} -eq 0 ]; then
echo -e "\nNo data found in CSV file. Preparing to remove all IPs from WAF policy ${policyName}."
updatedIPs="[]"
else
declare -A expectedIPs
for line in "${csvLines[@]}"; do
    ip=$(echo $line | cut -d',' -f1)
    customer=$(echo $line | cut -d',' -f2)
    expectedIPs[$ip]=$customer
    echo "$ip -$customer"
done

# Convert variables to arrays
IFS=' ' read -r -a currentIPsArray <<< "$currentIPs"
printf '%s\n' "${currentIPsArray[@]}"

# Determine IPs to add
IPsToAdd=()
echo -e "\n\n########### IPs to Add #################" 
for ip in "${!expectedIPs[@]}"; do
    if [[ ! " ${currentIPsArray[*]} " =~ " $ip " ]]; then
    IPsToAdd+=("$ip")
    echo "$ip -${expectedIPs[$ip]}"
    fi
done

# Determine IPs to remove
IPsToRemove=()
echo -e "\n\n########### IPs to Remove #################" 
for ip in "${currentIPsArray[@]}"; do
    if [[ -z "${expectedIPs[$ip]}" ]]; then
    IPsToRemove+=("$ip")
    echo "$ip -${expectedIPs[$ip]}"
    fi
done

# Prepare the updated IP list
updatedIPs=$(printf '%s\n' "${!expectedIPs[@]}" | jq -R . | jq -cs .)
echo -e "\n\nUpdated IP List: $updatedIPs"
fi

# Fetch existing managed rules
managedRules=$(az network front-door waf-policy managed-rules list --policy-name ${policyName} --resource-group ${resourceGroupName} -o json)

# Deploy updated IP list to WAF policy using Bicep template
echo -e "\n\nDeploying updated IP list to WAF policy ${policyName}..."
echo -e "\n\n##################################"
echo "############ DRY RUN #############"
echo "##################################"
az deployment group what-if \
--resource-group ${resourceGroupName} \
--template-file "./iac/${policyName}.bicep" \
--parameters frontDoorWafPolicyName=${policyName} customRuleName=${customRuleName} allowedIPAddresses="$updatedIPs" managedRuleSetDefinitions="$managedRules"

echo -e "\n\n##################################"
echo "########## DEPLOYMENT ############"
echo "##################################"
az deployment group create \
--resource-group ${resourceGroupName} \
--template-file "./iac/${policyName}.bicep" \
--parameters frontDoorWafPolicyName=${policyName} customRuleName=${customRuleName} allowedIPAddresses="$updatedIPs" managedRuleSetDefinitions="$managedRules"

echo -e "\n\n"

if [ $? -ne 0 ]; then
echo "Error: Deployment failed for policy ${policyName}. Exiting."
exit 1
fi

echo "Deployment successful for policy ${policyName}."