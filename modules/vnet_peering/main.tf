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


resource "azurerm_virtual_network_peering" "src-to-dst" {
  depends_on = [null_resource.dep_rg_created]
  name                      = "${var.source_vnet_name}-to-${var.destination_vnet_name}"
  resource_group_name       = var.rg_name
  virtual_network_name      = var.source_vnet_name
  remote_virtual_network_id = var.destination_vnet_id
}

resource "azurerm_virtual_network_peering" "dst-to-src" {
  depends_on = [null_resource.dep_rg_created]
  name                      = "${var.destination_vnet_name}-to-${var.source_vnet_name}"
  resource_group_name       = var.rg_name
  virtual_network_name      = var.destination_vnet_name
  remote_virtual_network_id = var.source_vnet_id
}