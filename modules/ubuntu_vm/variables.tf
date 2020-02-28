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

# The Public SSH Key which should be written to the path defined above.
variable "pubkey" {}

#The path of the destination file on the virtual machine
variable "keypath" {}

variable "dependency_rg_created" {}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

variable "tag_env" {
  default = "Terraform Demo"
}

variable "admin_username" {}

