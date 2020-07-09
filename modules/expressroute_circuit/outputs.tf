output "expressroute_service_key" {
  value = azurerm_express_route_circuit.poc-frankfurt.service_key
}

output "expresroute_circuit_name" {
  value = azurerm_express_route_circuit.poc-frankfurt.name
}

output "expresroute_circuit_id" {
  value = azurerm_express_route_circuit.poc-frankfurt.id
}