output "id" {
  description = "ID of the Bastion Host."
  value = azurerm_bastion_host.this.id
}
output "fqdn" {
  description = "FQDN of the Bastion Host."
  value = lookup(azurerm_bastion_host.this, "fqdn", "")
}

output "pip" {
  description = "Public IP address of the Bastion Host."
  value = azurerm_public_ip.this.id
}