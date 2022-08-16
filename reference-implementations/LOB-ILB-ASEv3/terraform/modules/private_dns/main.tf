resource "azurerm_private_dns_zone" "this" {
  name                = var.private_fqdn
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.private_fqdn
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.target_vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_a_record" "this" {
  for_each = var.private_dns_a_records

  name                = each.key
  records             = each.value.records
  ttl                 = lookup(each.value, "ttl", 3600)
  
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
}
