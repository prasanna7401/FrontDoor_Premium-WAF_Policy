param frontDoorWafPolicyName string
param location string = 'global'
param customRuleName string
param allowedIPAddresses array
param managedRuleSetDefinitions array

resource wafPolicy 'Microsoft.Network/frontDoorWebApplicationFirewallPolicies@2022-05-01' = {
  name: frontDoorWafPolicyName
  location: location
  sku: {
    name: 'Premium_AzureFrontDoor'
  }
  properties: {
    managedRules: { 
      managedRuleSets: managedRuleSetDefinitions
    }
    customRules: {
      rules: [
              // Rule - 1: The IPs added here are parsed from the CSV file.
              {
                name: customRuleName
                priority: 10
                ruleType: 'MatchRule'
                action: 'Block'  // Change to 'Allow' if needed
                enabledState: 'Enabled'
                matchConditions: [
                  {
                    matchVariable: 'SocketAddr'
                    operator: 'IPMatch'
                    matchValue: allowedIPAddresses
                    negateCondition: true  // This sets the "does not contain" operation
                    selector: ''
                    transforms: []
                  }
                ]
              }
              // Add more rules as per requirement
              // {
              //   matchVariable: 'SocketAddr'
              //   selector: null
              //   operator: 'CountryBlock'
              //   negateCondition: true
              //   matchValue: [
              //     'RU'
              //     'CN'
              //     'IR'
              //   ]
              //   transforms: []
              // }
            ]
          action: 'Allow'
        }
    }
    policySettings: {
      mode: 'Prevention'  // Change to 'Detection' if needed
      customBlockResponseStatusCode: 403
      customBlockResponseBody: 'Access Denied'
      enabledState: 'Enabled'
      requestBodyCheck: 'Enabled'
    }
  }
  tags: {
    environment: 'production'
    workload: 'azure_security'
    managedBy: 'Azure_DevOps'
  }
}
