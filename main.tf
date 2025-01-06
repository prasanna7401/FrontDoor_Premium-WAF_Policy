# Reference to existing RG
data "azurerm_resource_group" "waf_rg" {
  name = var.resource_group
}

# TEMPLATE:
# module "<YOUR-POLICY-NAME>" {
#   source              = "./modules/waf_policy"
#   policy_name         = var.your_waf_name # UPDATE THIS
#   resource_group_name = data.azurerm_resource_group.waf_rg.name
#   sku                 = var.fd_sku
#   mode                = var.waf_mode
#   location            = var.location
#   managed_rules       = var.managed_rules
#   tags                = var.tags
#   custom_rules        = var.your_waf_rules # UPDATE THIS
# }

module "testpolicy01" {
  source              = "./modules/waf_policy"
  policy_name         = var.test_waf_name
  resource_group_name = data.azurerm_resource_group.waf_rg.name
  sku                 = var.fd_sku
  mode                = var.waf_mode
  location            = var.location
  managed_rules       = var.managed_rules
  tags                = var.tags
  custom_rules        = var.test_rules # declared in waf_rules/test_rules.tfvars
}

module "prodpolicy" {
  source              = "./modules/waf_policy"
  policy_name         = var.prod_waf_name
  resource_group_name = data.azurerm_resource_group.waf_rg.name
  sku                 = var.fd_sku
  mode                = var.waf_mode
  location            = var.location
  managed_rules       = var.managed_rules
  tags                = var.tags
  custom_rules        = var.prod_rules # declared in waf_rules/prod_rules.tfvars
}