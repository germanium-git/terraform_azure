variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "rg_name" {}
variable "express_route_circuit_name" {}
variable "express_route_circuit_id" {}
variable "gateway_subnet_id" {}
variable "vnet_name" {}
variable "mng_access_from" {}

variable "primary_peering_subnet_cidr" {}
variable "secondary_peering_subnet_cidr" {}
variable "peer_asn" {}
variable "vlan_id" {}