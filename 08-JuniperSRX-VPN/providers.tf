terraform {
  required_providers {
    junos = {
      version = "~> 1.16.2"
      source = "jeremmfr/junos"
    }
    azurerm = {
      version = "~> 2.61.0"
    }
  }
}


provider "azurerm" {
  subscription_id = var.subscription_id
/*
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
*/
  features {}
}