variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "rg_name" {
  default = "rg-zsto-networking-nemedpet"
}

variable "pubkey" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKRP0OEAWmAxOTtUZ9beQmKm8t0sgghVAFj1QaseDbMFSprtznHXcU/EF7YWR4wgLI25xzj8aItXxbkNav0mSoHnsyBAmDi42XUCQ5j3snGmF8f8XXu0j49d8z5cBgmiRCheoIC31EtYGzu5bkiuhOOj0k5hAOVzMVgKRdcMasRRsnAQ+VRHtR1dAYRKYQQzaKUtbdfi42xgj4QlPWM0g1t8gOA/Z52hVdX564Zh5GatEQ5QFNTuA7OI4DH1B5E5zZJLNSwE+2Kyf2VZdwc/piIX3X5s1PnJ672JZOoVKwDEMgNYWXycosZBKt4hvbyC5sSiZYQbcBJ5REv9yJRNLwZ7r/Isr5kBYebZBsfOxa36XgKKvjvNGfL5JXNYcCA6nYoaqN+W4UMNjOQg37fDaUVNUxkNFJoUUaaOihYhrWr+Ak79TB7J3ej7huAyvYCZ+bjQOTLgcBinWBsHFTzrzyBtyKTxZRhwEMCpFXljwwtRWN9M7I21XcIvlcsUwNFEzFwmyYNiTg7PKFIwu+KttQXCeVf+WnAEovJe2lGpgsJTrngyeR8M1Pfe92NXe7o2CZ9hroxmULuXahWHro99/InZkobQOIBKEJ7jnppzomXapjpKtEDudQfhMLd8PXS9nnt8xv0Ldpoz9je1l37hRr6T2Ei5RLCM5cRtT2HWX/SQ== Ansible Tower"
}

variable "username" {}
variable "password" {}

# Specify rules in the Network Security Group protecting the management access to FortiGate Firewall
variable "nsg_rules" {
  description = "Network Security Group"
  type = map(list(string))

  # Structure is as follows name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]
  default = {
    #allowall = ["100", "Inbound", "Allow", "*", "*", "*", "*", "*",]
    SSH   = ["120", "Inbound", "Allow", "Tcp", "*", "22", "193.15.240.60/32", "*",]
    HTTPS = ["110", "Inbound", "Allow", "Tcp", "*", "443", "193.15.240.60/32", "*",]
    HTTP  = ["130", "Inbound", "Allow", "Tcp", "*", "80", "193.15.240.60/32", "*",]
    OutAll = ["100", "Outbound", "Allow", "*", "*", "*", "*", "*",]
  }
}

variable "mng_access_from" {
  default = "193.15.240.60/32"
}