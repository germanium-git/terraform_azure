# --Define locals to derive names of the resources to be deployed
locals {
  project_distinguisher = "vpn-s2s-bgp"
  environment = "Terraform demo"
}

# --Define the management IP address of the firewall running in on-premisses
variable "srx210" {
  default = "172.31.1.1"
}

# --Define the username to login to juniper firewall
variable "username" {
  default = "admin"
}

# --Define the password to login to juniper firewall
# -- Use rather public key authentication
# variable "password" {}

# --Define the ssh key to login to juniper firewall
variable "sshkeyfile" {
  default = "admin-srx210_privatekey_openssh"
}

# --Define the passphrase to unlock the SSH key to login to Juniper SRX firewall
# --Store the variable rather in terraform.tfvars to keep it secured
variable "keypass" {}


# --Define the location of the Azure VPN gateway
variable "location" {
  default = "West Europe"
}

# --Azure ASN
variable "azure_bgp_asn" {
  default = 64520
}

# --vNET CIDR range
variable "vnetcidr" {
  default = "172.16.0.0/16"
}

# --Workload subnet CIDR
variable "subnet1" {
  default = "172.16.1.0/24"
}

# --Gateway subnet CIDR
variable "gwsubnet" {
  default = "172.16.0.0/28"
}

# --Public IP address of the Juniper SRX firewall in the on-premisses site
variable "onprem_pubip" {
  default = "185.230.172.74"
}

# --Autonomous system of the on-premisses infra
variable "onprem_asn" {
  default = "65100"
}

# --Outside interface of the Juniper SRX firewall to establish VPN to Azure
variable "onprem_interface" {
  default = "fe-0/0/7.111"
}

# --IP address for BGP peering on Azure side
variable "tunnel_endpoint1" {
  default = "10.1.254.1"
}

# --Preshared key for VPN
# --Store the variable rather in terraform.tfvars to keep it secured
variable "tunnel1_preshared_key" {}

# --Tunnel interface on SRX firewall
variable "tunnel_interface" {
  default = "st0.0"
}

# --Security zone on SRX firewall
variable "sec_zone" {
  default = "untrust"
}

# -- Choose an existing policy to filter out routes exported to neighbor in Azure
variable "bgp_export" {
  default = "BGP-export"
}
