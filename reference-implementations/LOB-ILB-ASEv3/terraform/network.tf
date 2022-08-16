
# locals {
#   // Variables
#   bastionHostName     = "snet-basthost-${local.resourceSuffix}"
#   bastionHostPip      = "${local.bastionHostName}-pip"
#   hubVNetName         = "vnet-hub-${local.resourceSuffix}"
#   spokeVNetName       = "vnet-spoke-${local.resourceSuffix}"
#   bastionSubnetName   = "AzureBastionSubnet"
#   CICDAgentSubnetName = "snet-cicd-${local.resourceSuffix}"
#   jumpBoxSubnetName   = "snet-jbox-${local.resourceSuffix}"
#   aseSubnetName       = "snet-ase-${local.resourceSuffix}"

#   hubSubnets = { for subnet in azurerm_virtual_network.vnetHub.subnet : subnet.name => subnet.id }
# }


resource "azurerm_resource_group" "networkrg" {
  name     = "network-${module.azurecaf.results["azurerm_resource_group"]}"
  location = module.azurecaf.location

  tags = module.azurecaf.tags
}

module "hubspoke_vnets" {
  source = "./modules/hubspoke_vnets"
  name = module.azurecaf.results["azurerm_virtual_network"]

  location            = azurerm_resource_group.networkrg.location
  resource_group_name = azurerm_resource_group.networkrg.name

  hub_address_space = [var.hubVNetNameAddressPrefix]
  spoke_address_space = [var.aseAddressPrefix]

  hub_subnets = {
    "AzureBastionSubnet" = {
      address_prefixes = [var.bastionAddressPrefix]
    },
    "JumpBox" = {
      address_prefixes = [var.jumpBoxAddressPrefix]
    },
    "CICDAgent" = {
      address_prefixes = [var.CICDAgentNameAddressPrefix]
    }
  }

  spoke_subnets = {
    "hostingEnvironment" = {
      address_prefixes = [var.aseAddressPrefix]
      delegation = {
        name    = "Microsoft.Web/hostingEnvironments"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
      }
    }
  }

  tags = module.azurecaf.tags
}

module "bastion" {
  source = "./modules/bastion"

  name = "bastion-${module.azurecaf.results["azurerm_bastion_host"]}"
  location            = azurerm_resource_group.networkrg.location
  resource_group_name = azurerm_resource_group.networkrg.name
  subnet_id = module.hubspoke_vnets.hubSubnets["AzureBastionSubnet"]
  
  tags = module.azurecaf.tags
}

# // Resources - VNet - SubNets
# resource "azurerm_virtual_network" "vnetHub" {
#   name                = local.hubVNetName
#   location            = azurerm_resource_group.networkrg.location
#   resource_group_name = azurerm_resource_group.networkrg.name
#   address_space       = [var.hubVNetNameAddressPrefix]

#   subnet {
#     name           = "AzureBastionSubnet"
#     address_prefix = var.bastionAddressPrefix
#   }

#   subnet {
#     name           = "jumpBoxSubnetName"
#     address_prefix = var.jumpBoxAddressPrefix
#   }

#   subnet {
#     name           = "CICDAgentSubnetName"
#     address_prefix = var.CICDAgentNameAddressPrefix
#   }

#   depends_on = [azurerm_resource_group.networkrg]

# }

# // Resources - VNet - SubNets - Spoke
# resource "azurerm_virtual_network" "vnetSpoke" {
#   name                = local.spokeVNetName
#   location            = azurerm_resource_group.networkrg.location
#   resource_group_name = azurerm_resource_group.networkrg.name
#   address_space       = [var.spokeVNetNameAddressPrefix]
#   depends_on          = [azurerm_resource_group.networkrg]
# }

# resource "azurerm_subnet" "vnetSpokeSubnet" {
#   name                 = local.aseSubnetName
#   resource_group_name  = azurerm_resource_group.networkrg.name
#   virtual_network_name = azurerm_virtual_network.vnetSpoke.name
#   address_prefixes     = [var.aseAddressPrefix]

#   delegation {
#     name = "hostingEnvironment"

#     service_delegation {
#       name    = "Microsoft.Web/hostingEnvironments"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
#     }
#   }
#   depends_on = [azurerm_virtual_network.vnetSpoke]
# }

# // Peering
# resource "azurerm_virtual_network_peering" "peerhubtospoke" {
#   name                         = "peerhubtospoke"
#   resource_group_name          = azurerm_resource_group.networkrg.name
#   virtual_network_name         = azurerm_virtual_network.vnetHub.name
#   remote_virtual_network_id    = azurerm_virtual_network.vnetSpoke.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
#   depends_on                   = [azurerm_virtual_network.vnetHub, azurerm_virtual_network.vnetSpoke]
# }

# resource "azurerm_virtual_network_peering" "peerspoketohub" {
#   name                         = "peerspoketohub"
#   resource_group_name          = azurerm_resource_group.networkrg.name
#   virtual_network_name         = azurerm_virtual_network.vnetSpoke.name
#   remote_virtual_network_id    = azurerm_virtual_network.vnetHub.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = false
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
#   depends_on                   = [azurerm_virtual_network.vnetHub, azurerm_virtual_network.vnetSpoke]
# }

# //bastionHost
# resource "azurerm_public_ip" "bastionHostPippublicIp" {
#   name                = local.bastionHostPip
#   resource_group_name = azurerm_resource_group.networkrg.name
#   location            = azurerm_resource_group.networkrg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   depends_on          = [azurerm_resource_group.networkrg]
# }

# resource "azurerm_bastion_host" "bastionHost" {
#   name                = local.bastionHostName
#   location            = azurerm_resource_group.networkrg.location
#   resource_group_name = azurerm_resource_group.networkrg.name

#   ip_configuration {
#     name                 = "IpConf"
#     subnet_id            = "${azurerm_virtual_network.vnetHub.id}/subnets/AzureBastionSubnet"
#     public_ip_address_id = azurerm_public_ip.bastionHostPippublicIp.id
#   }
#   depends_on = [azurerm_virtual_network.vnetHub, azurerm_virtual_network.vnetSpoke]
# }

