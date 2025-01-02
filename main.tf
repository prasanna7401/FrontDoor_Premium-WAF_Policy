resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group
  tags     = var.tags
  lifecycle {
    prevent_destroy = true
  }
}

module "testpolicy01" {
  source              = "./modules/waf_policy"
  policy_name         = var.test_waf_name
  resource_group_name = var.resource_group
  sku                 = var.fd_sku
  mode                = var.waf_mode
  location            = var.location
  managed_rules       = var.managed_rules
  tags                = var.tags
  custom_rules        = var.test_rules # declared in rules/dev_rules.tf
}

module "prodpolicy" {
  source              = "./modules/waf_policy"
  policy_name         = var.prod_waf_name
  resource_group_name = var.resource_group
  sku                 = var.fd_sku
  mode                = var.waf_mode
  location            = var.location
  managed_rules       = var.managed_rules
  tags                = var.tags
  custom_rules        = var.prod_rules # declared in rules/prod_rules.tf
}

# Create more modules for different environments - based on the requirement