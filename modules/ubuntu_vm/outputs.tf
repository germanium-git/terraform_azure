output "ubuntu_vm_public_ip" {
  value = azurerm_public_ip.mypublicip.ip_address
}