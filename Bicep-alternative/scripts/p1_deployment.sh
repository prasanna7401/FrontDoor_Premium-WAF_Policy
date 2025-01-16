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

# Fetch existing managed rules
managedRules=$(az network front-door waf-policy managed-rules list --policy-name ${policyName} --resource-group ${resourceGroupName} -o json)
echo -e "\n\nPolicy name: ${policyName}"
echo -e "Resource group: ${resourceGroupName}\n\n"

updatedIPsFile="$PIPELINE_DIR/updatedIPsArtifact_${policyName}/updatedIPs_${policyName}.json"
if [ ! -f "$updatedIPsFile" ]; then
    echo "Error: File $updatedIPsFile not found. Exiting."
    exit 1
fi
updatedIPs=$(cat $updatedIPsFile)
echo -e "IP List for Deployment: $updatedIPs\n\n"

if [ -z "$updatedIPs" ]; then
    echo "No IPs to update. Exiting."
    exit 0
fi

# Ensure updatedIPs is in JSON array format
updatedIPsJson=$(echo $updatedIPs | jq -c '.')

# Exponential backoff retry logic for deployment
max_retries=10
retries=0
initial_wait_time=30  # Initial wait time of 30 seconds

while [ $retries -lt $max_retries ]; do
    echo "Attempting deployment (try $((retries + 1))/$max_retries)..."

    echo -e "\n\n##################################"
    echo "############ DRY RUN #############"
    echo "##################################"
    az deployment group what-if \
        --resource-group ${resourceGroupName} \
        --template-file "./iac/${policyName}.bicep" \
        --parameters frontDoorWafPolicyName=${policyName} customRuleName=${customRuleName} allowedIPAddresses="$updatedIPsJson" managedRuleSetDefinitions="$managedRules"

    echo -e "\n\n##################################"
    echo "########## DEPLOYMENT ############"
    echo "##################################"
    az deployment group create \
        --resource-group ${resourceGroupName} \
        --template-file "./iac/${policyName}.bicep" \
        --parameters frontDoorWafPolicyName=${policyName} customRuleName=${customRuleName} allowedIPAddresses="$updatedIPsJson" managedRuleSetDefinitions="$managedRules" \
        && break  # Exit loop if deployment succeeds


    echo "Deployment is still active or failed. Retrying in $((initial_wait_time * (2 ** retries))) seconds..."
    sleep $((initial_wait_time * (2 ** retries)))  # Exponential backoff
    retries=$((retries + 1))
done

if [ $retries -eq $max_retries ]; then
    echo "Deployment failed after $max_retries attempts."
    exit 1
fi