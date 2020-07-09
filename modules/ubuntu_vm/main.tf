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


resource "azurerm_public_ip" "publicip" {
    depends_on                 = [null_resource.dep_rg_created]
    name                       = var.vm_name
    location                   = "westeurope"
    resource_group_name        = var.rg_name
    allocation_method          = "Dynamic"

    tags = {
        environment = var.tag_env
    }
}

resource "azurerm_network_interface" "nic" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = var.vm_name
    location                  = "westeurope"
    resource_group_name       = var.rg_name
    network_security_group_id = var.nsg_id

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip.id
    }

    tags = {
        environment = var.tag_env
    }
}

resource "azurerm_virtual_machine" "ubuntu-16-04-0-lts" {
    depends_on              = [null_resource.dep_rg_created, azurerm_public_ip.publicip]
    name                    = var.vm_name
    location                = var.location
    resource_group_name     = var.rg_name
    network_interface_ids   = [azurerm_network_interface.nic.id]
    vm_size                 = var.vm_size
    delete_os_disk_on_termination = true

    storage_os_disk {
        name                = "osdisk-${var.vm_name}"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = var.vm_name
        admin_username = var.admin_username
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = var.keypath
            key_data = var.pubkey
        }
    }

    tags = {
        environment = var.tag_env
    }
}


