module "myrg" {
    source = "../modules/res_group"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    rg_name = var.rg_name
}


module "fg_ha" {
    source                = "../modules/fgfw_ha_multiple_zones"
    subscription_id       = var.subscription_id
    client_id             = var.client_id
    client_secret         = var.client_secret
    tenant_id             = var.tenant_id
    rg_name               = var.rg_name
    dependency_rg_created = module.myrg.rg_created
    outside_subnet_cidr   = "10.0.0.0/24"
    inside_subnet_cidr    = "10.0.1.0/24"
    hb_subnet_cidr        = "10.0.2.0/24"
    mng_subnet_cidr       = "10.0.3.0/24"
    test_subnet_cidr      = "10.0.4.0/24"
    vnet_name             = module.vnet.vnet_name
    nsg_id                = module.vnet.nsg_id
    username              = var.username
    password              = var.password
    mng_access_from       = var.mng_access_from
}


module "vnet" {
    source = "../modules/vnet_v2"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = "vnet-01"
    vnet_address_space = "10.0.0.0/16"
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
    nsg_name = "allowallnsg"
    nsg_rules = var.nsg_rules
}

module "ubuntu_vm-01" {
    source = "../modules/ubuntu_vm"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vm_name = "ubuntu-vm-01"
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
    nsg_id = module.vnet.nsg_id
    subnet_id = module.fg_ha.test-subnet-id
    pubkey = var.pubkey
}
