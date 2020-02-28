variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default = "westeurope"
}

variable "rg_name" {}

variable "tag_env" {
  default = "Terraform Demo"
}