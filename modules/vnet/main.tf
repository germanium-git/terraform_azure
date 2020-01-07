provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}

# Wait until the resource group is created
resource "null_resource" "dep_rg_created" {
  provisioner "local-exec" {
    command = "echo The resource group is created - ${var.dependency_rg_created}"
  }
}


resource "azurerm_virtual_network" "myvnet" {
    depends_on = [null_resource.dep_rg_created]
    name                = var.vnet_name
    address_space       = [var.vnet_address_space]
    location            = var.location
    resource_group_name = var.rg_name
}


resource "azurerm_network_security_group" "mysg" {
    depends_on = [null_resource.dep_rg_created]
    name                = var.vnet_name
    location            = var.location
    resource_group_name = var.rg_name

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

    security_rule {
        name                       = "FromOtherVNets"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "ToOtherVNets"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}
