variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "rg_name" {
  default = "rg-zsto-networking-nemedpet"
}

variable "admin_username" {
  default = "azureuser"
}

# The path of the destination file on the virtual machine where the key will be written.
variable "keypath" {
  default = "/home/azureuser/.ssh/authorized_keys"
}


variable "vnet_name" {
  default = "MyTestVNet"
}

variable "vnet01_address_space" {
 default = "10.1.0.0/16"
}

variable "vnet02_address_space" {
 default = "10.2.0.0/16"
}


# Specify rules in the Network Security Group protecting the management access to FortiGate Firewall
variable "nsg_rules" {
  description = "Network Security Group"
  type = map(list(string))

  # Structure is as follows name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]
  default = {
    #allowall = ["100", "Inbound", "Allow", "*", "*", "*", "*", "*",]
    SSH   = ["110", "Inbound", "Allow", "Tcp", "*", "22", "193.15.240.60/32", "*",]
    AllVNETIn = ["100", "Inbound", "Allow", "*", "*", "*", "10.0.0.0/8", "*",]
    OutAll = ["100", "Outbound", "Allow", "*", "*", "*", "*", "*",]
  }
}

variable "mng_access_from" {
  default = "193.15.240.60/32"
}