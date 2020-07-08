provider "azurerm" {
  version = "~> 2.1"
  features {}
}

terraform {
    backend "azurerm" {
        key = "azure.tfstate"
    }
}
