terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

data "azurerm_client_config" "demo" {}

provider "azurerm" {
  features {}
}
