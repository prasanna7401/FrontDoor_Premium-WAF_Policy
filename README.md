# Azure FrontDoor Premium - Web Application Firewall Policy management

## Recommended WAF Custom Rule structure for easy management

1. AllowedIPs
2. AllowedCountries
3. CombinationRules
4. BlockedIPs
5. BlockedCountries
6. Others

## Manage rules

Update the tfvars file based on the environment:
    1. [Dev](./policydev/waf_rules/custom_rules.tfvars)
    2. [Prod](./policyprod/waf_rules/custom_rules.tfvars)

## How to?

1. Update rules:
    - to be filled later
2. How to add/manage a new WAF policy?
    Step-1: Add a the following in each code, by copy-pasting the other waf content in accordance with your new WAF policy name.
    - a new module in `main.tf`
    - a variable definition in `variables.tf`
    - a variable declaration in `terraform.tfvars`
    - a rule set in `rules/`, by importing the new device configuration to be managed by terraform. See below for importing procedures,
    
    Step-2: Import a new already-existing WAF policy configurations to statefile:
    ```sh
    tf import -var-file="<WAF_RULE_1.tfvars>" -var-file="<WAF_RULE_2.tfvars>" ... module.<NEW_WAF_MODULE_NAME>.azurerm_cdn_frontdoor_firewall_policy.waf_policy <ARM_ID>
    ```

    > Note: This import step needs to be run only once, when you want to import the configurations of an existing resource to get managed by terraform for the first time. Provide the backend storage container details as required.

    Step-3: Add/update the `-var-file=rules/<NEW_WAF_RULES>.tfvars` to every `plan` and `apply` steps in the pipeline.

### Special note

- If you would like to use this code to manage existing FD WAF, you should run `terraform import` to update your statefile, and have only required attributes.

-  While running `terraform import`, you may face errors like, `Error: ID was missing the 'frontDoorWebApplicationFirewallPolicies' element`. In this case, you should change the sentence casing in the resourceID from `frontdoorwebapplicationfirewallpolicies` to `frontDoorWebApplicationFirewallPolicies`.

- Before running `terraform destroy`, do not forget to remove the state configurations of the resources you have imported, to avoid unnecessary deletion. Use, `terraform state rm <resource_id>`.

- As a best practice, always `lifecycle {}` block in your code, to avoid accidental resource deletion/modification.