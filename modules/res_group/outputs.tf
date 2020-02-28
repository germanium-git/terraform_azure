output "rs_group_name" {
  value = azurerm_resource_group.rg.name
}

output "rs_group_id" {
  value = azurerm_resource_group.rg.id
}

# Dependency setter for rg created
output "rg_created" {
  value = null_resource.rg_created.id
}