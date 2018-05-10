provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

data "azurerm_resource_group" "myterraformgroup" {
    name     = "rg-zsto-networking-demo"
}

resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westeurope"
    resource_group_name = "${data.azurerm_resource_group.myterraformgroup.name}"

    subnet {
    name           = "subnet1"
    address_prefix = "10.0.0.0/25"
    }

    tags {
        environment = "Terraform Demo"
    }
}
