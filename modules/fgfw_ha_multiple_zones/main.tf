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

# Create public ip for FortiGate-A
resource "azurerm_public_ip" "fgtamgmtip" {
  depends_on              = [null_resource.dep_rg_created]
  name                    = "fgtamgmtip"
  location                = var.location
  resource_group_name     = var.rg_name
  sku                     = "Standard"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

# Create public ip for FortiGate-B
resource "azurerm_public_ip" "fgtbmgmtip" {
  depends_on              = [null_resource.dep_rg_created]
  name                    = "fgtbmgmtip"
  location                = var.location
  resource_group_name     = var.rg_name
  sku                     = "Standard"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

# Create public ip for Cluster
resource "azurerm_public_ip" "tClusterPublicIP" {
  depends_on              = [null_resource.dep_rg_created]
  name                    = "tClusterPublicIP"
  location                = var.location
  resource_group_name     = var.rg_name
  sku                     = "Standard"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

# Create the route table for internal protected clients
resource "azurerm_route_table" "inside" {
  depends_on                    = [null_resource.dep_rg_created]
  name                          = "default-udr"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name                   = "defaultroute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost(var.inside_subnet_cidr, 70)
  }

  route {
    name                   = "mng_access"
    address_prefix         = var.mng_access_from
    next_hop_type          = "Internet"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_route_table" "outside" {
  depends_on                    = [null_resource.dep_rg_created]
  name                          = "tooutside"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name                   = "defaultroute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }

  tags = {
    environment = "Production"
  }
}


resource "azurerm_subnet" "inside" {
  depends_on           = [null_resource.dep_rg_created]
  name                 = "fg-inside"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.inside_subnet_cidr
}

resource "azurerm_subnet" "outside" {
  depends_on           = [null_resource.dep_rg_created]
  name                 = "fg-outside"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.outside_subnet_cidr
}

resource "azurerm_subnet" "hb" {
  depends_on           = [null_resource.dep_rg_created]
  name                 = "fg-hb"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.hb_subnet_cidr
}

resource "azurerm_subnet" "mgmt" {
  depends_on           = [null_resource.dep_rg_created]
  name                 = "fg-mng"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.mng_subnet_cidr
}

resource "azurerm_subnet" "test" {
  depends_on           = [null_resource.dep_rg_created]
  name                 = "vm-test"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.test_subnet_cidr
}

resource "azurerm_subnet_route_table_association" "outside" {
  subnet_id      = azurerm_subnet.outside.id
  route_table_id = azurerm_route_table.outside.id
}

resource "azurerm_subnet_route_table_association" "mgmt" {
  subnet_id      = azurerm_subnet.mgmt.id
  route_table_id = azurerm_route_table.outside.id
}

resource "azurerm_subnet_route_table_association" "test" {
  subnet_id      = azurerm_subnet.test.id
  route_table_id = azurerm_route_table.inside.id
}

# Outside interface A
resource "azurerm_network_interface" "nic-a-public" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtaport1"
    location                  = var.location
    resource_group_name       = var.rg_name
    network_security_group_id = var.nsg_id

    ip_configuration {
        name                          = "nic-a-public-cfg"
        subnet_id                     = azurerm_subnet.outside.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.outside_subnet_cidr, 70)
        public_ip_address_id          = azurerm_public_ip.tClusterPublicIP.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Outside interface A
resource "azurerm_network_interface" "nic-b-public" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtbport1"
    location                  = var.location
    resource_group_name       = var.rg_name
    network_security_group_id = var.nsg_id

    ip_configuration {
        name                          = "nic-b-public-cfg"
        subnet_id                     = azurerm_subnet.outside.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.outside_subnet_cidr, 80)
    }

    tags = {
        environment = "Terraform Demo"
    }
}


# Inside interface A
resource "azurerm_network_interface" "nic-a-internal" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtaport2"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "nic-a-internal-cfg"
        subnet_id                     = azurerm_subnet.inside.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.inside_subnet_cidr, 70)
    }

    tags = {
        environment = "Terraform Demo"
    }
}


# Inside interface B
resource "azurerm_network_interface" "nic-b-internal" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtbport2"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "nic-b-internal-cfg"
        subnet_id                     = azurerm_subnet.inside.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.inside_subnet_cidr, 80)
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# HB interface A
resource "azurerm_network_interface" "nic-a-hb" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtaport3"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "nic-a-hb-cfg"
        subnet_id                     = azurerm_subnet.hb.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.hb_subnet_cidr, 70)
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# HB interface B
resource "azurerm_network_interface" "nic-b-hb" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtbport3"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "nic-b-hb-cfg"
        subnet_id                     = azurerm_subnet.hb.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.hb_subnet_cidr, 80)
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Mgmt interface A
resource "azurerm_network_interface" "nic-a-mgmt" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtaport4"
    location                  = var.location
    resource_group_name       = var.rg_name
    network_security_group_id = var.nsg_id

    ip_configuration {
        name                          = "nic-a-mng-cfg"
        subnet_id                     = azurerm_subnet.mgmt.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.mng_subnet_cidr, 70)
        public_ip_address_id          = azurerm_public_ip.fgtamgmtip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Mgmt interface B
resource "azurerm_network_interface" "nic-b-mgmt" {
    depends_on                = [null_resource.dep_rg_created]
    name                      = "tfgtbport4"
    location                  = var.location
    resource_group_name       = var.rg_name
    network_security_group_id = var.nsg_id

    ip_configuration {
        name                          = "nic-b-mng-cfg"
        subnet_id                     = azurerm_subnet.mgmt.id
        private_ip_address_allocation = "Static"
        private_ip_address            = cidrhost(var.mng_subnet_cidr, 80)
        public_ip_address_id          = azurerm_public_ip.fgtbmgmtip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}


resource "azurerm_virtual_machine" "master" {
    depends_on            = [null_resource.dep_rg_created,
      azurerm_network_interface.nic-a-mgmt,
      azurerm_network_interface.nic-a-internal,
      azurerm_network_interface.nic-a-public,
      azurerm_network_interface.nic-a-hb,
      azurerm_public_ip.tClusterPublicIP,
      azurerm_public_ip.fgtamgmtip]
    name                  = "master"
    location              = var.location
    resource_group_name   = var.rg_name
    network_interface_ids = [
      azurerm_network_interface.nic-a-public.id,
      azurerm_network_interface.nic-a-internal.id,
      azurerm_network_interface.nic-a-hb.id,
      azurerm_network_interface.nic-a-mgmt.id]
    primary_network_interface_id = azurerm_network_interface.nic-a-public.id
    vm_size              = "Standard_DS3_v2"
    zones                = [1]

    plan {
      name = "fortinet_fg-vm"
      product = "fortinet_fortigate-vm_v5"
      publisher = "fortinet"
    }

    storage_os_disk {
        name              = "master"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "fortinet"
        offer     = "fortinet_fortigate-vm_v5"
        sku       = "fortinet_fg-vm"
        version   = "latest"
    }

    os_profile_linux_config{
        disable_password_authentication = false

    }
    os_profile {
        computer_name  = "fg-master"
        admin_username = var.username
        admin_password = var.password
        custom_data    = file("./configs/azureinit-a.conf")
    }

    tags = {
        environment = "Terraform Demo"
    }
}


resource "azurerm_virtual_machine" "slave" {
    depends_on            = [null_resource.dep_rg_created,
      azurerm_public_ip.tClusterPublicIP,
      azurerm_network_interface.nic-b-mgmt,
      azurerm_network_interface.nic-b-internal,
      azurerm_network_interface.nic-b-public,
      azurerm_network_interface.nic-b-hb,
      azurerm_public_ip.fgtbmgmtip]
    name                  = "slave"
    location              = var.location
    resource_group_name   = var.rg_name
    network_interface_ids = [
      azurerm_network_interface.nic-b-public.id,
      azurerm_network_interface.nic-b-internal.id,
      azurerm_network_interface.nic-b-hb.id,
      azurerm_network_interface.nic-b-mgmt.id]
    primary_network_interface_id = azurerm_network_interface.nic-b-public.id
    vm_size              = "Standard_DS3_v2"
    zones                = [2]

    plan {
      name = "fortinet_fg-vm"
      product = "fortinet_fortigate-vm_v5"
      publisher = "fortinet"
    }

    storage_os_disk {
        name              = "slave"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "fortinet"
        offer     = "fortinet_fortigate-vm_v5"
        sku       = "fortinet_fg-vm"
        version   = "latest"
    }

    os_profile_linux_config{
        disable_password_authentication = false

    }
    os_profile {
        computer_name  = "fg-slave"
        admin_username = var.username
        admin_password = var.password
        custom_data    = file("./configs/azureinit-b.conf")
    }

    tags = {
        environment = "Terraform Demo"
    }
}
