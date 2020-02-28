variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "dependency_rg_created" {}

variable "rg_name" {}
variable "vnet_name" {}

variable "gw_subnet_cidr" {}
variable "gateway_address" {}

variable "address_space" {}
variable "mng_access_from" {}


# Internal subnets to be associated with a specific routing table directing traffic to VPN gateway
variable "subnetid_to_rt_associate" {}

variable "list_remote_subnets" {}

variable "tag_env" {
  default = "Terraform Demo"
}