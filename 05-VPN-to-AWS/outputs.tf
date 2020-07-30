output "azure_resource_group" {
  value = azurerm_resource_group.rg.name
}

output "azure_vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "azure_subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "azure_subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "aws_subnet_id" {
  value = aws_subnet.main.id
}