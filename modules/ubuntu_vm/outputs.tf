output "ubuntu_vm_public_ip" {
  value = azurerm_public_ip.publicip.ip_address
}

output "ubuntu_vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "ubuntu_vm_mac_address" {
  value = azurerm_network_interface.nic.mac_address
}