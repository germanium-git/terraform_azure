variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "vm_name" {}

variable "rg_name" {}
variable "subnet_id" {}
variable "nsg_id" {}
variable "pubkey" {}

variable "dependency_rg_created" {}