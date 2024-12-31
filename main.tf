resource "azurerm_resource_group" "rg01" {
  location = var.location
  name     = var.resource_group
  tags     = var.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_cdn_frontdoor_profile" "fd01" {
  name                     = var.fd_name
  resource_group_name      = var.resource_group
  response_timeout_seconds = 60
  sku_name                 = var.fd_sku
  tags                     = var.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_cdn_frontdoor_firewall_policy" "testpolicy01" {
  name                = var.waf_name
  resource_group_name = var.resource_group
  sku_name            = var.fd_sku
  mode                = var.waf_mode
  tags                = var.tags

  dynamic "custom_rule" {
    for_each = var.custom_rules
    content {
      action                         = custom_rule.value.action
      enabled                        = custom_rule.value.enabled
      name                           = custom_rule.value.name
      priority                       = custom_rule.value.priority
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_threshold
      type                           = custom_rule.value.type

      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          match_values       = match_condition.value.match_values
          match_variable     = match_condition.value.match_variable
          negation_condition = match_condition.value.negation_condition
          operator           = match_condition.value.operator
          transforms         = match_condition.value.transforms
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = var.managed_rules
    content {
      action  = managed_rule.value.action
      type    = managed_rule.value.type
      version = managed_rule.value.version
    }
    
  }

  lifecycle {
    ignore_changes = [mode] # Ignore changes to the mode of the WAF policy
  }
}