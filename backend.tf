terraform {
  backend "azurerm" {
    resource_group_name  = "misc"
    storage_account_name = "kborowiecsa"
    container_name       = "tfstate"
    key                  = "aks.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
    subscription_id      = "24dfd03c-5baf-4ce8-9431-a31a4ed13748"
    tenant_id            = "76a7d5d1-22cf-47b4-ba85-0b1620bde9da"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.5.0"
    }
  }
}

provider "azurerm" {
  features {}

}

