module "vnet" {
    source = "../modules/vnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_address_space = "10.0.0.0/16"
    rg_name = var.rg_name
}

module "subnet-01" {
    source = "../modules/subnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = module.vnet.vnet_name
    rg_name = var.rg_name
    subnet_name = "internal-01"
    subnet_cidr = "10.0.1.0/24"
}

module "subnet-02" {
    source = "../modules/subnet"
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
    vnet_name = module.vnet.vnet_name
    rg_name = var.rg_name
    subnet_name = "internal-02"
    subnet_cidr = "10.0.2.0/24"
}

module "ubuntu_vm-01" {
    source                = "../modules/ubuntu_vm"
    subscription_id       = var.subscription_id
    client_id             = var.client_id
    client_secret         = var.client_secret
    tenant_id             = var.tenant_id
    vm_name               = "ubuntu-vm-01"
    dependency_rg_created = module.vnet.rg_created
    rg_name               = var.rg_name
    nsg_id                = module.vnet.nsg_id
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
    dependency_rg_created = module.vnet.rg_created
    rg_name = var.rg_name
    nsg_id = module.vnet.nsg_id
    subnet_id = module.subnet-02.subnet-id
    pubkey = var.pubkey
}
