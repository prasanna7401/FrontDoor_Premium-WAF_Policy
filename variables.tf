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

variable "waf_name" {
  type        = string
  description = "The name of the WAF policy"
}

variable "waf_mode" {
  type        = string
  description = "The mode of the WAF policy"
  default     = "Prevention"
}

variable "fd_name" {
  type        = string
  description = "The name of the front door"
}

variable "fd_sku" {
  type        = string
  description = "The SKU of the WAF policy"
  default     = "Premium_AzureFrontDoor"
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



































# variable "be_storage_account" {
#   type        = string
#   description = "The name of the backend storage account"
#   default     = "tftestwaf" # CHANGE
# }

# variable "be_container_name" {
#   type        = string
#   description = "The container name for the backend config"
#   default     = "tfstate"
# }

# variable "be_tfstate_key" {
#   type        = string
#   description = "The access key for the storage account"
#   default     = "testwaf01.terraform.tfstate"
# }



################################################################
# variable "subscription-id" {
#   type        = string
#   description = "value of the subscription id" # fetched from environment variable
#   default = "c0d0d92e-feae-4639-abcd-9f1e39dcd916"
# }

# variable "tenant-id" {
#   type        = string
#   description = "value of the tenant id" # fetched from environment variable
# }

# variable "client-id" {
#   type        = string
#   description = "value of the service principal client id" # fetched from environment variable
# }

# variable "client-secret" {
#   type        = string
#   description = "value of the service principal client secret" # fetched from environment variable
# }