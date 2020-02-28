module "myrg" {
    source                  = "../modules/res_group"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    rg_name                 = var.rg_name
}

module "vnet" {
    source                  = "../modules/vnet"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vnet_name               = var.vnet_name
    dependency_rg_created   = module.myrg.rg_created
    vnet_address_space      = var.vnet_address_space
    rg_name                 = var.rg_name
    nsg_name                = "TestVNET"
    nsg_rules               = var.nsg_rules
}

module "vpn" {
    source                   = "../modules/vpn"
    subscription_id          = var.subscription_id
    client_id                = var.client_id
    client_secret            = var.client_secret
    tenant_id                = var.tenant_id
    vnet_name                = var.vnet_name
    dependency_rg_created    = module.myrg.rg_created
    rg_name                  = var.rg_name
    gateway_address          = var.gateway_address
    gw_subnet_cidr           = cidrsubnet(var.vnet_address_space, 8, 0)
    # Backdoor route to Internet for management access
    mng_access_from          = var.mng_access_from
    subnetid_to_rt_associate = module.subnet-01.subnet-id
    list_remote_subnets      = values(var.address_space)
    address_space            = var.address_space
}


module "subnet-01" {
    source                  = "../modules/subnet"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vnet_name               = var.vnet_name
    dependency_rg_created   = module.myrg.rg_created
    dependency_vnet_created = module.vnet.vnet_created
    rg_name                 = var.rg_name
    subnet_name             = "internal-01"
    subnet_cidr             = cidrsubnet(var.vnet_address_space, 8, 1)
}


module "ubuntu_vm-01" {
    source                  = "../modules/ubuntu_vm"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vm_name                 = "ubuntu-test-vpn"
    dependency_rg_created   = module.myrg.rg_created
    rg_name                 = var.rg_name
    nsg_id                  = module.vnet.nsg_id
    subnet_id               = module.subnet-01.subnet-id
    pubkey                  = file("../key/id_rsa.pub")
    keypath                 = var.keypath
    admin_username          = var.admin_username
}
