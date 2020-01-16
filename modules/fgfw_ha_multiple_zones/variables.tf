variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "rg_name" {}

variable "dependency_rg_created" {}

variable "vnet_name" {}
variable "inside_subnet_cidr" {}
variable "outside_subnet_cidr" {}
variable "hb_subnet_cidr" {}
variable "mng_subnet_cidr" {}

variable "nsg_id" {}

variable "username" {}
variable "password" {}

variable "test_subnet_cidr" {}

variable "mng_access_from" {}