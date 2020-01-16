output "fg-a-pub-mng-ip" {
  value = azurerm_public_ip.fgtamgmtip.ip_address
}

output "fg-b-pub-mng-ip" {
  value = azurerm_public_ip.fgtbmgmtip.ip_address
}

output "fg-outside-mng-ip" {
  value = azurerm_public_ip.tClusterPublicIP.ip_address
}

output "test-subnet-id" {
  value = azurerm_subnet.test.id
}