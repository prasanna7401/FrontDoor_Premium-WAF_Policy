### WAF POLICY VARIABLES ###

# TEMPLATE
#
# variable "your_waf_name" {
#   type        = string
#   description = "The name of the WAF policy"
# }
#
# variable "your_waf_rules" {
#   type = list(object({
#     action                         = string
#     enabled                        = bool
#     name                           = string
#     priority                       = number
#     rate_limit_duration_in_minutes = number
#     rate_limit_threshold           = number
#     type                           = string
#     match_conditions = list(object({
#       match_values       = list(string)
#       match_variable     = string
#       negation_condition = bool
#       operator           = string
#       transforms         = list(string)
#     }))
#   }))
# }
variable "test_waf_name" {
  type        = string
  description = "The name of the WAF policy"
}
variable "test_rules" {
  type = list(object({
    action                         = string
    enabled                        = bool
    name                           = string
    priority                       = number
    rate_limit_duration_in_minutes = number
    rate_limit_threshold           = number
    type                           = string
    match_conditions = list(object({
      match_values       = list(string)
      match_variable     = string
      negation_condition = bool
      operator           = string
      transforms         = list(string)
    }))
  }))
}

variable "prod_waf_name" {
  type        = string
  description = "The name of the WAF policy"
}
variable "prod_rules" {
  type = list(object({
    action                         = string
    enabled                        = bool
    name                           = string
    priority                       = number
    rate_limit_duration_in_minutes = number
    rate_limit_threshold           = number
    type                           = string
    match_conditions = list(object({
      match_values       = list(string)
      match_variable     = string
      negation_condition = bool
      operator           = string
      transforms         = list(string)
    }))
  }))
}

##### COMMON PROPERTIES #####

variable "managed_rules" {
  type = list(object({
    action  = string
    type    = string
    version = string
  }))
}

variable "resource_group" {
  type        = string
  description = "The name of the backend storage account resource group"
}

variable "location" {
  type        = string
  description = "The region for the deployment"
  default     = "westus2"
}

variable "tags" {
  type        = map(string)
  description = "Tags used for the deployment"
  default = {
    "deployment" = "terraform-managed"
  }
}

variable "waf_mode" {
  type        = string
  description = "The mode of the WAF policy"
  default     = "Prevention"
}

variable "fd_sku" {
  type        = string
  description = "The SKU of the WAF policy"
  default     = "Premium_AzureFrontDoor"
}