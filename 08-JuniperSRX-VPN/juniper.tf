# --Configure the Junos Provider for SRX210
provider "junos" {
  alias       = "SRX210"
  ip          = var.srx210
  username    = var.username
  #password   = var.password
  sshkeyfile  = var.sshkeyfile
  keypass     = var.keypass
  port        = 22
}

# --Add a ike proposal
resource junos_security_ike_proposal "demo_vpn_proposal" {
  provider                  = junos.SRX210
  name                      = "azure"
  authentication_algorithm  = "sha1"
  encryption_algorithm      = "aes-256-cbc"
  dh_group                  = "group2"
  lifetime_seconds          = 28800
}

# --Add a ike policy
resource junos_security_ike_policy "demo_vpn_policy" {
  provider                  = junos.SRX210
  name                      = "azure"
  proposals                 = [junos_security_ike_proposal.demo_vpn_proposal.name]
  pre_shared_key_text       = var.tunnel1_preshared_key
}

# --Add a ike gateway
resource junos_security_ike_gateway "demo_vpn_p1" {
  provider                  = junos.SRX210
  name                      = "azure"
  #address                   = ["1.2.3.4"]
  address                   = [tostring(azurerm_public_ip.gwpip.ip_address)]
  policy                    = junos_security_ike_policy.demo_vpn_policy.name
  external_interface        = var.onprem_interface
  version                   = "v2-only"

  dead_peer_detection {
    interval  = 10
    threshold = 5
  }
  local_identity {
    type = "inet"
    value = var.onprem_pubip
  }
}

# --Add a ipsec proposal
resource junos_security_ipsec_proposal "demo_vpn_proposal" {
  provider                  = junos.SRX210
  name                      = "azure"
  authentication_algorithm  = "hmac-sha-256-128"
  encryption_algorithm      = "aes-256-cbc"
  lifetime_seconds          = 3600
  protocol                  = "esp"
}


# --Add a ipsec policy
resource junos_security_ipsec_policy "demo_vpn_policy" {
  provider                  = junos.SRX210
  name                      = "azure"
  proposals                 = [junos_security_ipsec_proposal.demo_vpn_proposal.name]
  pfs_keys                  = "group2"
}


# --Create st0 interface
resource junos_interface_logical "int_st0_0" {
  provider    = junos.SRX210
  name        = var.tunnel_interface
  description = "VPN to Azure"
  security_inbound_protocols = ["bgp"]
  security_inbound_services = ["ike"]
  security_zone = "untrust"

  family_inet {
    address {
      cidr_ip = "${var.tunnel_endpoint1}/32"
    }
  }
}


# --Add a route-based ipsec vpn
resource junos_security_ipsec_vpn "demo_vpn" {
  provider          = junos.SRX210
  name              = "azure"
  establish_tunnels = "immediately"
  bind_interface    = var.tunnel_interface

  ike {
    gateway = junos_security_ike_gateway.demo_vpn_p1.name
    policy  = junos_security_ipsec_policy.demo_vpn_policy.name
    identity_local = "0.0.0.0/0"
    identity_remote = "0.0.0.0/0"
    identity_service = "any"
  }
}


# --Add a static route to BGP neighbor
resource junos_static_route "demo_static_route" {
  provider         = junos.SRX210
  destination      = "${cidrhost(var.gwsubnet, 10)}/32"
  routing_instance = "default"
  next_hop         = ["st0.0"]
}


# --Configure a BGP group
resource junos_bgp_group "ebgp" {
  provider         = junos.SRX210
  name             = "ebgp"
  type             = "external"
  hold_time        = 30
  routing_instance = "default"
  peer_as          = var.azure_bgp_asn
  multihop         = true
  log_updown       = true

  bfd_liveness_detection {
    minimum_interval = 1000
    multiplier = 3
    transmit_interval_minimum_interval = 1000
  }

  family_inet {
    nlri_type = "unicast"
  }

  family_inet6 {
    nlri_type = "unicast"
  }
}


# --Configure the BGP neighbor on Azure side
resource junos_bgp_neighbor "azurevpn" {
  provider         = junos.SRX210
  ip               = cidrhost(var.gwsubnet, 10)
  routing_instance = "default"
  group            = junos_bgp_group.ebgp.name
  peer_as          = var.azure_bgp_asn
  export           = [var.bgp_export]
}
