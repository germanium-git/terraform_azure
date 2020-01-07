variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "rg_name" {}

variable "source_vnet_name" {}
variable "destination_vnet_name" {}
variable "source_vnet_id" {}
variable "destination_vnet_id" {}

variable "dependency_rg_created" {}