variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "rg_name" {
  default = "myRG"
}

variable "admin_username" {
  default = "azureuser"
}

# The path of the destination file on the virtual machine where the key will be written.
variable "keypath" {
  default = "/home/azureuser/.ssh/authorized_keys"
}

variable "vnet_name" {
  default = "VPN-TEST"
}

variable "vnet_address_space" {
 default = "10.0.0.0/16"
}

# On-premisse CIDR
variable "address_space" {
  type = map(string)
  default = {
    subnet1 = "172.31.1.0/24"
    subnet2 = "172.31.2.0/24"
    subnet3 = "172.31.3.0/24"
  }
}


# Specify rules in the Network Security Group protecting the management access to FortiGate Firewall
variable "nsg_rules" {
  description = "Network Security Group"
  type = map(list(string))

  # Structure is as follows name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]
  default = {
    #allowall  = ["100", "Inbound", "Allow", "*", "*", "*", "*", "*",]
    VNETIntAll = ["100", "Inbound", "Allow", "*", "*", "*", "10.0.0.0/16", "*",]
    RemoteLAN  = ["110", "Inbound", "Allow", "*", "*", "*", "172.31.1.0/24", "*",]
    SSH        = ["120", "Inbound", "Allow", "Tcp", "*", "22", "193.15.240.60/32", "*",]
    SSH-2      = ["130", "Inbound", "Allow", "Tcp", "*", "22", "185.230.173.4/32", "*",]
    VNETOutAll = ["100", "Outbound", "Allow", "*", "*", "*", "*", "*",]
  }
}

variable "mng_access_from" {
  default = "193.15.240.60/32"
}

variable "gateway_address" {
  default = "158.255.22.70"
}

