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


resource "azurerm_subnet" "internal" {
  depends_on = [null_resource.dep_rg_created]
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefix       = var.subnet_cidr
}
