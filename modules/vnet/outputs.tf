output "vnet_name" {
  value = azurerm_virtual_network.myvnet.name
}

output "nsg_id" {
  value = azurerm_network_security_group.mysg.id
}

# Dependency setter for rg created
output "rg_created" {
  value = null_resource.rg_created.id
}