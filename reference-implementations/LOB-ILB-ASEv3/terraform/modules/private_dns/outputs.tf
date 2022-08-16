output "private_dns_a_records" {
  description = "Map of A records created through this module."
  value = azurerm_private_dns_a_record.this
}

output "id" {
  description = "ID of the private DNS zone." 
  value = azurerm_private_dns_zone.this.id
}

output "name" {
  description = "Name of the private DNS zone." 
  value = azurerm_private_dns_zone.this.name
}

