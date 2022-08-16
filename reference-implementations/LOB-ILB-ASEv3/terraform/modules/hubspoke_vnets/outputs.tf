output "hubVnetId" {
  description = "ID of the hub virtual network."
  value       = azurerm_virtual_network.vnetHub.id
}
output "hubVnetName" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.vnetHub.name
}

output "spokeVnetId" {
  description = "ID of the spoke virtual network."
  value       = azurerm_virtual_network.vnetSpoke.id
}
output "spokeVnetName" {
  description = "Name of the spoke virtual network."
  value       = azurerm_virtual_network.vnetSpoke.name
}

output "hubSubnets" {
  description = "IDs of the hub subnets."
  value       = length(var.hub_subnets) > 0 ? { for subnet in azurerm_subnet.subnetsHub : subnet.name => subnet.id } : {}
}


output "spokeSubnets" {
  description = "IDs of the hub subnets."
  value       = length(var.hub_subnets) > 0 ? { for subnet in azurerm_subnet.subnetsSpoke : subnet.name => subnet.id } : {}
}

