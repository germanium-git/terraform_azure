output "FGVM-A-mng-ip" {
  value = module.fg_ha.fg-a-pub-mng-ip
}

output "FGVM-B-mng-ip" {
  value = module.fg_ha.fg-b-pub-mng-ip
}

output "Cluster-outside-ip" {
  value = module.fg_ha.fg-outside-mng-ip
}

output "Ubuntu-vm-ip" {
  value = module.ubuntu_vm-01.ubuntu_vm_public_ip
}