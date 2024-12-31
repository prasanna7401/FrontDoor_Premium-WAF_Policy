terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.11.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none" # Skip provider registration
  # storage_use_azuread             = true
  # use_oidc                        = true
  # use_cli                         = false
  # subscription_id                 = var.subscription-id
  # tenant_id                       = var.tenant-id
  # client_id                       = var.client-id
  # client_secret                   = var.client-secret
}