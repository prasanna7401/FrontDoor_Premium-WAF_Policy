terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.11.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "<your-resource-group>"
  #   storage_account_name = "<your-storage-account>"
  #   container_name       = "<your-container>"
  #   key                  = "waf/pipeline.terraform.tfstate" # Modify based on your requirement
  # }
}

provider "azurerm" {
  features {}
  use_oidc                        = true
  resource_provider_registrations = "none" # Skip provider registration
}