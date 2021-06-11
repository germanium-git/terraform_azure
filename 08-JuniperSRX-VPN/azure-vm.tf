# --Create NIC without public IP
resource "azurerm_network_interface" "nic" {
    name                      = "nic-${local.project_distinguisher}"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "nic-10th-priv-ipaddress"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(azurerm_subnet.subnet.address_prefix, 10 )
    }
}


# --Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}


# --Create VM
resource "azurerm_virtual_machine" "ubuntu16-04" {
    name                    = "vm-${local.project_distinguisher}"
    location                = var.location
    resource_group_name     = azurerm_resource_group.rg.name
    network_interface_ids   = [azurerm_network_interface.nic.id]
    vm_size                 = "Standard_DS1_v2"
    delete_os_disk_on_termination = true

    storage_os_disk {
        name                = "osdisk-vm-${local.project_distinguisher}"
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
        computer_name  = "vm-${local.project_distinguisher}"
        admin_username = var.admin_username
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = var.keypath
            key_data = file(var.pubkey)
        }
    }
}


