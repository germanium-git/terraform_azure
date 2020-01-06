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


resource "azurerm_virtual_network" "myvnet" {
    name = "myVnet"
    address_space = [var.vnet_address_space]
    location = var.location
    resource_group_name = azurerm_resource_group.myrg.name
}

resource "azurerm_network_security_group" "mysg" {
    name                = "nsg-demo-vm"
    location            = var.location
    resource_group_name = azurerm_resource_group.myrg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}
