module "vnet" {
    source                          = "../modules/vnet"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    vnet_name                       = var.vnet_name
    # Ignore dependency; RG is already created
    dependency_rg_created           = var.rg_name
    vnet_address_space              = var.vnet_address_space
    rg_name                         = var.rg_name
    nsg_name                        = "IntraVNET"
    nsg_rules                       = var.nsg_rules
}

# Create gateway subnet
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/875
# Requirement on the Azure side that the subnet is named GatewaySubnet
module "subnet-00" {
    source                          = "../modules/subnet"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    vnet_name                       = var.vnet_name
    # Ignore dependency; RG is already created
    dependency_rg_created           = var.rg_name
    dependency_vnet_created         = module.vnet.vnet_created
    rg_name                         = var.rg_name
    subnet_name                     = "GatewaySubnet"
    subnet_cidr                     = cidrsubnet(var.vnet_address_space, 8, 0)
}

# Create VM subnet
module "subnet-01" {
    source                          = "../modules/subnet"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    vnet_name                       = var.vnet_name
    # Ignore dependency; RG is already created
    dependency_rg_created           = var.rg_name
    dependency_vnet_created         = module.vnet.vnet_created
    rg_name                         = var.rg_name
    subnet_name                     = "internal-01"
    subnet_cidr                     = cidrsubnet(var.vnet_address_space, 8, 1)
}


module "ubuntu_vm-01" {
    source                          = "../modules/ubuntu_vm"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    vm_name                         = "ubuntu-vm-01"
    # Ignore dependency; RG is already created
    dependency_rg_created           = var.rg_name
    rg_name                         = var.rg_name
    nsg_id                          = module.vnet.nsg_id
    subnet_id                       = module.subnet-01.subnet-id
    pubkey                          = file("../key/id_rsa.pub")
    keypath                         = var.keypath
    admin_username                  = var.admin_username
}


module "ubuntu_vm-02" {
    source                          = "../modules/ubuntu_vm"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    vm_name                         = "ubuntu-vm-02"
    # Ignore dependency; RG is already created
    dependency_rg_created           = var.rg_name
    rg_name                         = var.rg_name
    nsg_id                          = module.vnet.nsg_id
    subnet_id                       = module.subnet-01.subnet-id
    pubkey                          = file("../key/id_rsa.pub")
    keypath                         = var.keypath
    admin_username                  = var.admin_username
}


module "expressroute" {
    source                          = "../modules/expressroute_circuit"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    rg_name                         = var.rg_name
    service_provider_name           = "Equinix"
    peering_location                = "Frankfurt"
}


module expresspeering {
    source                          = "../modules/expressroute_peering"
    subscription_id                 = var.subscription_id
    client_id                       = var.client_id
    client_secret                   = var.client_secret
    tenant_id                       = var.tenant_id
    rg_name                         = var.rg_name
    express_route_circuit_name      = module.expressroute.expresroute_circuit_name
    express_route_circuit_id        = module.expressroute.expresroute_circuit_id
    gateway_subnet_id               = module.subnet-00.subnet-id
    mng_access_from                 = var.mng_access_from
    peer_asn                        = "64521"
    primary_peering_subnet_cidr     = "10.255.0.0/30"
    secondary_peering_subnet_cidr   = "10.255.0.4/30"
    vlan_id                         = "123"
    vnet_name                       = module.vnet.vnet_name
}
