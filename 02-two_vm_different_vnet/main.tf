module "myrg" {
    source = "../modules/res_group"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    rg_name = var.rg_name
}

module "vnet-01" {
    source = "../modules/vnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = "vnet-01"
    vnet_address_space = "10.1.0.0/16"
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
}

module "vnet-02" {
    source = "../modules/vnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = "vnet-02"
    vnet_address_space = "10.2.0.0/16"
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
}

module "subnet-01" {
    source = "../modules/subnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = module.vnet-01.vnet_name
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
    subnet_name = "internal-01"
    subnet_cidr = "10.1.0.0/24"
}

module "subnet-02" {
    source = "../modules/subnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = module.vnet-02.vnet_name
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
    subnet_name = "internal-02"
    subnet_cidr = "10.2.0.0/24"
}

module "ubuntu_vm-01" {
    source                = "../modules/ubuntu_vm"
    subscription_id       = var.subscription_id
    client_id             = var.client_id
    client_secret         = var.client_secret
    tenant_id             = var.tenant_id
    vm_name               = "ubuntu-vm-01"
    dependency_rg_created = module.myrg.rg_created
    rg_name               = var.rg_name
    nsg_id                = module.vnet-01.nsg_id
    subnet_id             = module.subnet-01.subnet-id
    pubkey                = var.pubkey
}

module "ubuntu_vm-02" {
    source = "../modules/ubuntu_vm"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vm_name = "ubuntu-vm-02"
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
    nsg_id = module.vnet-02.nsg_id
    subnet_id = module.subnet-02.subnet-id
    pubkey = var.pubkey
}

module "peering_vnet-01-to-02" {
    source = "../modules/vnet_peering"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    dependency_rg_created = module.myrg.rg_created
    rg_name = var.rg_name
    source_vnet_name = module.vnet-01.vnet_name
    source_vnet_id = module.vnet-01.vnet_id
    destination_vnet_name = module.vnet-02.vnet_name
    destination_vnet_id = module.vnet-02.vnet_id
}