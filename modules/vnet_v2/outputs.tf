output "vnet_name" {
  value = azurerm_virtual_network.myvnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.myvnet.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg01.id
}
