##### WAF POLICY VARIABLES #####

# TEMPLATE:
# your_waf_name = "<YOUR-WAF-POLICY-NAME>"

test_waf_name = "testwafpolicy"
prod_waf_name = "prodwafpolicy"




##### COMMON PROPERTIES #####
resource_group = "<YOUR-RESOURCE-GROUP-NAME>"
location       = "<YOUR-LOCATION>"

tags = {
  workload        = "azure_security"
  deployment_type = "terraform-managed"
  environment     = "dev"
}

waf_mode = "Prevention"

managed_rules = [
  {
    action  = "Block"
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
  },
  {
    action  = "Log"
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.1"
  }
]