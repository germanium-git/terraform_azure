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

# Creation of the vnet depends on the RG
resource "azurerm_virtual_network" "vnet" {
    depends_on          = [null_resource.dep_rg_created]
    name                = var.vnet_name
    address_space       = [var.vnet_address_space]
    location            = var.location
    resource_group_name = var.rg_name
}


resource "azurerm_network_security_group" "nsg" {
    depends_on          = [null_resource.dep_rg_created]
    name                = var.nsg_name
    location            = var.location
    resource_group_name = var.rg_name

    tags = {
        environment = var.tag_env
    }
}


resource "azurerm_network_security_rule" "sec_rule" {
    for_each                    = var.nsg_rules
    resource_group_name         = var.rg_name
    network_security_group_name = azurerm_network_security_group.nsg.name
    name                        = each.key
    priority                    = each.value[0]
    direction                   = each.value[1]
    access                      = each.value[2]
    protocol                    = each.value[3]
    source_port_range           = each.value[4]
    destination_port_range      = each.value[5]
    source_address_prefix       = each.value[6]
    destination_address_prefix  = each.value[7]
}


# Wait until the VNET is created
resource "null_resource" "dep_vnet_created" {
    depends_on = [azurerm_virtual_network.vnet]
    provisioner "local-exec" {
        command = "echo The VNET is created - ${azurerm_virtual_network.vnet.name}"
    }
}

