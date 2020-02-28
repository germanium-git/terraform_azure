output "subnet-id" {
  value = azurerm_subnet.subnet.id
}

output "subnet-cidr" {
  value = azurerm_subnet.subnet.address_prefix
}

output "subnet-name" {
  value = azurerm_subnet.subnet.name
}