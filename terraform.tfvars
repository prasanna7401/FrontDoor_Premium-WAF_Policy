##### WAF Policies - ADD/UPDATE based on requirement #####

test_waf_name = "testwafpolicy"
prod_waf_name = "prodwafpolicy"




##### COMMON PROPERTIES #####
resource_group = "<your-resource-group>"
location       = "<your-location>"

tags = {
  deployment_type = "terraform-managed"
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