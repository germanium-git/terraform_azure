variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "rg_name" {}
variable "subnet_name" {}
variable "subnet_cidr" {}
variable "vnet_name" {}
variable "dependency_rg_created" {}
variable "dependency_vnet_created" {}