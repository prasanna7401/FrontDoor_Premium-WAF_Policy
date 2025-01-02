variable "policy_name" {
    description = "The name of the WAF policy"
    type = string  
}

variable "resource_group_name" {
    description = "The name of the resource group"
    type = string
}

variable "location" {
    description = "The location of the resource group"
    type = string  
}

variable "sku" {
    description = "The SKU of the WAF policy"
    type = string
}

variable "mode" {
    description = "The mode of the WAF policy"
    type = string
}

variable "tags" {
    description = "Tags for the WAF policy"
    type = map(string)
    default = {}
}

variable "custom_rules" {
  type        = list(object({
    action                         = string
    enabled                        = bool
    name                           = string
    priority                       = number
    rate_limit_duration_in_minutes = number
    rate_limit_threshold           = number
    type                           = string
    match_conditions               = list(object({
      match_values       = list(string)
      match_variable     = string
      negation_condition = bool
      operator           = string
      transforms         = list(string)
    }))
  }))
  description = "List of custom rules for the WAF policy"
}

variable "managed_rules" {
  type        = list(object({
    action  = string
    type    = string
    version = string
  }))
  description = "List of managed rules for the WAF policy"
}