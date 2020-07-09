provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}


resource "azurerm_express_route_circuit" "poc-frankfurt" {
  name                  = "Equiniq-POC-Frankfurt"
  resource_group_name   = var.rg_name
  location              = var.location
  service_provider_name = var.service_provider_name
  peering_location      = var.peering_location
  bandwidth_in_mbps     = 500

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  allow_classic_operations = false

  tags = {
    environment = "Equiniq-POC-Frankfurt"
  }
}
