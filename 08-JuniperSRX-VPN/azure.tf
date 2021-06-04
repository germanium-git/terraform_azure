# --Create resource group
resource "azurerm_resource_group" "rg" {
    name            = "rg-${local.project_distinguisher}"
    location        = var.location

    tags = {
        environment = local.environment
    }
}

# --Create vNet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnetcidr]
}

# --Create subnet for workloads
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet1]
}

# --Create gateway subnet
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.gwsubnet]
}

# --Create a public IP address for VPN Gateway
resource "azurerm_public_ip" "gwpip" {
  name                    = "vnetvgwpip1"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

# --Show the IP address on display when created.
output "vpn-public-ip" {
  value = azurerm_public_ip.gwpip.ip_address
}


resource "azurerm_virtual_network_gateway" "vng" {
  name                = "myvng1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.gwpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }

  bgp_settings {
    asn = var.azure_bgp_asn
    peering_address = cidrhost(var.gwsubnet, 10)
  }
}

resource "azurerm_local_network_gateway" "lngw1" {
    name                = "azlngw1"
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.location
    gateway_address     = var.onprem_pubip
    address_space       = ["${var.tunnel_endpoint1}/32"]


    bgp_settings {
        asn = var.onprem_asn
        bgp_peering_address = var.tunnel_endpoint1
    }
}


resource "azurerm_virtual_network_gateway_connection" "vngc1" {
    name                        = "vngc1"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.rg.name

    type                       = "IPsec"
    virtual_network_gateway_id = azurerm_virtual_network_gateway.vng.id
    local_network_gateway_id   = azurerm_local_network_gateway.lngw1.id

    shared_key = var.tunnel1_preshared_key

    enable_bgp = true
}
