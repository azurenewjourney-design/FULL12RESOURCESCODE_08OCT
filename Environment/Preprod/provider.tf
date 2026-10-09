terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-preprod"
    storage_account_name = "stterraformpreprod6543"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth = true

  }
}

provider "azurerm" {
  features {}
}