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
    vnet_address_space      = var.vnet_address_space
    dependency_rg_created   = module.myrg.rg_created
    rg_name                 = module.myrg.rs_group_name
    nsg_name                = "IntraVNET"
    nsg_rules               = var.nsg_rules
}

module "subnet-01" {
    source                  = "../modules/subnet"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vnet_name               = module.vnet.vnet_name
    dependency_rg_created   = module.myrg.rg_created
    dependency_vnet_created = module.vnet.vnet_created
    rg_name                 = var.rg_name
    subnet_name             = "internal-01"
    subnet_cidr             = cidrsubnet(var.vnet_address_space, 8, 1)
}

module "subnet-02" {
    source                  = "../modules/subnet"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vnet_name               = module.vnet.vnet_name
    dependency_rg_created   = module.myrg.rg_created
    dependency_vnet_created = module.vnet.vnet_created
    rg_name                 = var.rg_name
    subnet_name             = "internal-02"
    subnet_cidr             = cidrsubnet(var.vnet_address_space, 8, 2)
}

module "ubuntu_vm-01" {
    source                  = "../modules/ubuntu_vm"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vm_name                 = "ubuntu-vm-01"
    dependency_rg_created   = module.myrg.rg_created
    rg_name                 = var.rg_name
    nsg_id                  = module.vnet.nsg_id
    subnet_id               = module.subnet-01.subnet-id
    pubkey                  = file("../key/id_rsa.pub")
    keypath                 = var.keypath
    admin_username          = var.admin_username
}

module "ubuntu_vm-02" {
    source                  = "../modules/ubuntu_vm"
    subscription_id         = var.subscription_id
    client_id               = var.client_id
    client_secret           = var.client_secret
    tenant_id               = var.tenant_id
    vm_name                 = "ubuntu-vm-02"
    dependency_rg_created   = module.myrg.rg_created
    rg_name                 = var.rg_name
    nsg_id                  = module.vnet.nsg_id
    subnet_id               = module.subnet-02.subnet-id
    pubkey                  = file("../key/id_rsa.pub")
    keypath                 = var.keypath
    admin_username          = var.admin_username
}

