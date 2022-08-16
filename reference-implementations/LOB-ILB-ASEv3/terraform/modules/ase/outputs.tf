output "id" {
  description = "ID of the App Service Environment(v3)." 
  value = azurerm_app_service_environment_v3.ase.id
}

output "name" {
  description = "Name of the App Service Environment(v3)." 
  value = azurerm_app_service_environment_v3.ase.name
}

output "dns_suffix" {
  description = "DNS suffix of the App Service Environment(v3)." 
  value = azurerm_app_service_environment_v3.ase.dns_suffix
}