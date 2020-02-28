provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
    name            = var.rg_name
    location        = var.location

    tags = {
        environment = var.tag_env
    }
}

# Create null resource when RG is created
# Used as a dependency setter for other resources dependant on the resource group
resource "null_resource" "rg_created" {
  depends_on        = [azurerm_resource_group.rg]
  provisioner "local-exec" {
    command = "echo The resource group is created - ${azurerm_resource_group.rg.name}"
  }
}

