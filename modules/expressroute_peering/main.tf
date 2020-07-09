provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}


resource "azurerm_express_route_circuit_peering" "example" {
  peering_type                  = "AzurePrivatePeering"
  # Acceptable values include AzurePrivatePeering, AzurePublicPeering and MicrosoftPeering
  express_route_circuit_name    = var.express_route_circuit_name
  resource_group_name           = var.rg_name
  peer_asn                      = var.peer_asn
  primary_peer_address_prefix   = var.primary_peering_subnet_cidr
  secondary_peer_address_prefix = var.secondary_peering_subnet_cidr
  vlan_id                       = var.vlan_id
}


# Create a public IP for Virtual Network Gateway
resource "azurerm_public_ip" "vnetgw_pub_ip" {
  name                = "vnetgw_pub_ip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network_gateway" "equinix-poc" {
  name                = "EQX-POC-GW"
  location            = var.location
  resource_group_name = var.rg_name

  type                = "ExpressRoute"
  active_active       = false
  enable_bgp          = false
  sku                 = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vnetgw_pub_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }
}

/*
# Custom UDR is not needed
# Create the route table for internal protected clients
resource "azurerm_route_table" "inside" {
  name                          = "default-udr"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name                   = "defaultroute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualNetworkGateway"
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
*/


resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                        = "vnet-to-expressroute"
  location                    = var.location
  resource_group_name         = var.rg_name

  type                        = "ExpressRoute"
  virtual_network_gateway_id  = azurerm_virtual_network_gateway.equinix-poc.id
  express_route_circuit_id    = var.express_route_circuit_id
}