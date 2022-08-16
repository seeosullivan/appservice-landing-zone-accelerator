resource "azurerm_virtual_network" "vnetHub" {
  name                = "hub-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_address_space

  tags = merge(
    var.tags,
    {
      "SpokeVNetName" : "spoke-${var.name}"
    }
  )
}

// Resources - VNet - SubNets - Spoke
resource "azurerm_virtual_network" "vnetSpoke" {
  name                = "spoke-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke_address_space

  tags = merge(
    var.tags,
    {
      "HubVNetName" : azurerm_virtual_network.vnetHub.name
    }
  )
}

resource "azurerm_subnet" "subnetsHub" {
  for_each             = var.hub_subnets
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnetHub.name

  name             = each.key
  address_prefixes = each.value.address_prefixes


  dynamic "delegation" {
    for_each = lookup(each.value, "delegations", {}) == {} ? [] : [1]

    content {
      name = each.key

      service_delegation {
        name    = each.value.delegation["name"]
        actions = each.value.delegation["actions"]
      }
    }
  }
}

resource "azurerm_subnet" "subnetsSpoke" {
  for_each = var.spoke_subnets

  name                = each.key
  resource_group_name = var.resource_group_name
  address_prefixes    = each.value.address_prefixes

  virtual_network_name = azurerm_virtual_network.vnetSpoke.name

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [1] : []

    content {
      name = each.value.delegation.name

      service_delegation {
        name    = each.value.delegation.name
        actions = each.value.delegation.actions
      }
    }
  }
}

// Peering
resource "azurerm_virtual_network_peering" "peerhubtospoke" {
  name                         = "peerhubtospoke-${var.name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnetHub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnetSpoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "peerspoketohub" {
  name                         = "peerspoketohub-${var.name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnetSpoke.name
  remote_virtual_network_id    = azurerm_virtual_network.vnetHub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}