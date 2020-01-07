provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "myrg" {
    name     = var.rg_name
    location = var.location

    tags = {
        environment = "Terraform Demo"
    }
}


resource "null_resource" "rg_created" {
  depends_on = [azurerm_resource_group.myrg]
}
