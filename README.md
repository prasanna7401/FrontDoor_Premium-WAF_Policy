# Azure FrontDoor Premium - Web Application Firewall Policy management

## 1. Recommended WAF Custom Rule structure for easy management

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

### Special note

- If you would like to use this code to manage existing FD WAF, you should run `terraform import` to update your statefile, and have only required attributes.

-  While running `terraform import`, you may face errors like, `Error: ID was missing the 'frontDoorWebApplicationFirewallPolicies' element`. In this case, you should change the sentence casing in the resourceID from `frontdoorwebapplicationfirewallpolicies` to `frontDoorWebApplicationFirewallPolicies`.

- Before running `terraform destroy`, do not forget to remove the state configurations of the resources you have imported, to avoid unnecessary deletion. Use, `terraform state rm <resource_id>`.

- As a best practice, always `lifecycle {}` block in your code, to avoid accidental resource deletion/modification.