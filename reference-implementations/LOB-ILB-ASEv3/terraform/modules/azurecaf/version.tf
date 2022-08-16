terraform {
  required_providers {
    azurerm = ">=3.15.1, <4.0.0"
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview-3"
    }
  }
}

provider "azurerm" {
  features {}
}
