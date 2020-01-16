variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "vnet_name" {}
variable "vnet_address_space" {}

variable "rg_name" {}

variable "dependency_rg_created" {}

variable "nsg_rules" {}
variable "nsg_name" {}