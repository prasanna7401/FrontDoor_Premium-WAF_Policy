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

echo -e "\n\nStarting synchronization for WAF policy: ${policyName}\n\n"

# Fetch current IPs from WAF policy
currentIPs=$(az network front-door waf-policy rule list --resource-group ${resourceGroupName} --policy-name ${policyName} --query "[?name=='${customRuleName}'].matchConditions[0].matchValue[]" -o tsv | tr '\n' ' ' | tr -d '\r')

mapfile -t csvLines < <(awk -F',' '{print $1","$2}' ${csvPath})

echo "########################################"
echo "##### Expected IPs and Customers #######"
echo "########################################"

declare -A expectedIPs
for line in "${csvLines[@]}"; do
    ip=$(echo $line | cut -d',' -f1)
    customer=$(echo $line | cut -d',' -f2)
    expectedIPs[$ip]=$customer
    echo "$ip -$customer"
done

# Convert variables to arrays
IFS=' ' read -r -a currentIPsArray <<< "$currentIPs"
echo -e "\n\n########################################"
echo "##### Currently Configured IPs #########"
echo "########################################"
printf '%s\n' "${currentIPsArray[@]}"

if [ ${#csvLines[@]} -eq 0 ]; then
    echo "No data found in CSV file. Preparing to remove all IPs from WAF policy ${policyName}."
    updatedIPs="[]"
else
    echo -e "\n\n########### IPs to Add #################"             
    # Determine IPs to add
    IPsToAdd=()
    for ip in "${!expectedIPs[@]}"; do
        if [[ ! " ${currentIPsArray[*]} " =~ " $ip " ]]; then
            IPsToAdd+=("$ip")
            echo " $ip -${expectedIPs[$ip]}"
        fi
    done

    # Determine IPs to remove
    echo -e "\n\n########### IPs to Remove ##############"                 
    IPsToRemove=()
    for ip in "${currentIPsArray[@]}"; do
        if [[ -z "${expectedIPs[$ip]}" ]]; then
            IPsToRemove+=("$ip")
            if [ -z "${expectedIPs[$ip]}" ]; then
                echo "$ip - unknown"
            else
                echo "$ip -${expectedIPs[$ip]})"
            fi
        fi
    done

    echo -e "\n\n"

    # Prepare the updated IP list
    if [ ${#IPsToAdd[@]} -eq 0 ] && [ ${#IPsToRemove[@]} -eq 0 ]; then
        echo "No IPs to add or remove. Creating artifact with current IPs."
        updatedIPs=$(printf '%s\n' "${currentIPsArray[@]}" | jq -R . | jq -cs .)
        echo "Updated IP List: $updatedIPs"
    else
        updatedIPs=$(printf '%s\n' "${!expectedIPs[@]}" | jq -R . | jq -cs .)
        echo "Updated IP List: $updatedIPs"
    fi
fi

# Save the updated IP list to a file for the next job
outputFilePath="./updatedIPs_${policyName}.json"
echo "$updatedIPs" > "$outputFilePath"

echo "Verifying file creation..."
if [ -f "$outputFilePath" ]; then
    echo ""
else
    echo "Error: File $outputFilePath was not created."
    exit 1
fi