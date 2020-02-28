output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

# Dependency setter indicating that VNET is created
output "vnet_created" {
  value = null_resource.dep_vnet_created.id
}