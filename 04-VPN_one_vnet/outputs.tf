output "vm-01-public-ip" {
  value = module.ubuntu_vm-01.ubuntu_vm_public_ip
}

output "vm-01-private-ip" {
  value = module.ubuntu_vm-01.ubuntu_vm_private_ip
}

output "vm-01-mac" {
  value = module.ubuntu_vm-01.ubuntu_vm_mac_address
}

