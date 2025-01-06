terraform {
  required_version = ">= 1.10.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.11.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-pva-test"
    storage_account_name = "tftestwaf"
    container_name       = "tfstate"
    key                  = "waf/pipeline.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  use_oidc                        = true
  resource_provider_registrations = "none" # Skip provider registration
}