output "vm-01-public-ip" {
  value = module.ubuntu_vm-01.ubuntu_vm_public_ip
}

output "vm-02-public-ip" {
  value = module.ubuntu_vm-02.ubuntu_vm_public_ip
}

output "expressroute_circuit_servicekey" {
  value = module.expressroute.expressroute_service_key
}

output "subnet-00-cidr" {
  value = module.subnet-00.subnet-cidr
}

output "subnet-00-name" {
  value = module.subnet-00.subnet-name
}

output "subnet-01-cidr" {
  value = module.subnet-01.subnet-cidr
}

output "subnet-01-name" {
  value = module.subnet-01.subnet-name
}