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


resource "azurerm_subnet" "gw_subnet" {
  depends_on          = [null_resource.dep_rg_created]
  name                 = "GatewaySubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.gw_subnet_cidr
}

resource "azurerm_local_network_gateway" "onpremise" {
  depends_on          = [null_resource.dep_rg_created]
  name                = "onpremise"
  location            = var.location
  resource_group_name = var.rg_name
  gateway_address     = var.gateway_address
  address_space       = var.list_remote_subnets
}

resource "azurerm_public_ip" "gw_public_ip" {
  depends_on          = [null_resource.dep_rg_created]
  name                = "gw_public_ip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  depends_on          = [null_resource.dep_rg_created]
  name                = "VPN-GW"
  location            = var.location
  resource_group_name = var.rg_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.gw_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gw_subnet.id
  }

  /*
  bgp_settings {
    asn = "65001"
    peering_address =
    peer_weight =
  }
  */
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "onpremise"
  location            = var.location
  resource_group_name = var.rg_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onpremise.id

  shared_key = "4ggt7Gq!66tq8^wdkyhyqiPPh$10b-5h4r3dk3y"
}


# Create the route table for internal protected clients
resource "azurerm_route_table" "rtable" {
  depends_on                    = [null_resource.dep_rg_created]
  name                          = "default-udr"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  /*
  route {
    name                   = "defaultroute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }

  route {
    name                   = "remote_LAN"
    address_prefix         = var.remote_lan_cidr
    next_hop_type          = "VirtualNetworkGateway"
  }
  */

  tags = {
    environment = var.tag_env
  }
}


resource "azurerm_route" "tovpn" {
  depends_on          = [null_resource.dep_rg_created]
  for_each            = var.address_space
  name                = each.key
  resource_group_name = var.rg_name
  route_table_name    = azurerm_route_table.rtable.name
  address_prefix      = each.value
  next_hop_type       = "VirtualNetworkGateway"
}

resource "azurerm_route" "mngbackdoor" {
  depends_on          = [null_resource.dep_rg_created]
  name                = "MNGBackdoor"
  resource_group_name = var.rg_name
  route_table_name    = azurerm_route_table.rtable.name
  address_prefix      = var.mng_access_from
  next_hop_type       = "Internet"
}


/*
resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = var.subnetid_to_rt_associate
  route_table_id = azurerm_route_table.rtable.id
}
*/