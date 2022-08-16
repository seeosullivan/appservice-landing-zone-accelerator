resource "azurerm_resource_group" "aserg" {
  name     = "ase-${module.azurecaf.results["azurerm_resource_group"]}"
  location = module.azurecaf.location

  tags = module.azurecaf.tags
}

resource "azurerm_app_service_environment_v3" "ase" {
  name                         = module.azurecaf.results["azurerm_app_service_environment"]
  resource_group_name          = azurerm_resource_group.aserg.name
  subnet_id                    = module.hubspoke_vnets.spokeSubnets["hostingEnvironment"]
  internal_load_balancing_mode = "Web, Publishing"
  zone_redundant               = true
}

module "privateDns" {
  source = "./modules/private_dns"

  private_fqdn        = "${azurerm_app_service_environment_v3.ase.name}.appserviceenvironment.net"
  target_vnet_id      = module.hubspoke_vnets.spokeVnetId
  resource_group_name = azurerm_resource_group.aserg.name

  private_dns_a_records = {
    "*" = {
      records = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
      ttl     = 3600
    },
    "*.scm" = {
      records = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
      ttl     = 3600
    },
    "@" = {
      records = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
      ttl     = 3600
    }
  }
}

# TODO: Add app service plan, app service


# locals {
#   // Variables
#   vnetId             = azurerm_virtual_network.vnetSpoke.id
#   aseSubnetId        = "${azurerm_virtual_network.vnetSpoke.id}/subnets/${local.aseSubnetName}"
#   numberOfWorkers    = var.numberOfWorkers
#   workerPool         = var.workerPool
#   aseName            = substr("ase-${local.resourceSuffix}", 0, 37)
#   appServicePlanName = "asp-${local.resourceSuffix}"
#   privateDnsZoneName = "${local.aseName}.appserviceenvironment.net"
# }

# resource "azurerm_app_service_environment_v3" "ase" {
#   name                         = local.aseName
#   resource_group_name          = azurerm_resource_group.aserg.name
#   subnet_id                    = local.aseSubnetId
#   internal_load_balancing_mode = "Web, Publishing"
#   zone_redundant               = true
#   depends_on                   = [azurerm_bastion_host.bastionHost]
# }



# resource "azurerm_service_plan" "appServicePlan" {
#   name                       = local.appServicePlanName
#   location                   = azurerm_resource_group.aserg.location
#   resource_group_name        = azurerm_resource_group.aserg.name
#   app_service_environment_id = azurerm_app_service_environment_v3.ase.id
#   per_site_scaling_enabled   = false
#   zone_balancing_enabled     = true

#   os_type      = "Windows"
#   sku_name     = "I${local.workerPool}v2"
#   worker_count = local.numberOfWorkers

#   depends_on = [azurerm_bastion_host.bastionHost]
# }

# resource "azurerm_private_dns_zone" "privateDnsZone" {
#   name                = local.privateDnsZoneName
#   resource_group_name = azurerm_resource_group.aserg.name
#   depends_on          = [azurerm_app_service_environment_v3.ase]
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "privateDnsZoneName_vnetLink" {
#   name                  = "vnetLink"
#   resource_group_name   = azurerm_resource_group.aserg.name
#   private_dns_zone_name = local.privateDnsZoneName
#   virtual_network_id    = local.vnetId
#   registration_enabled  = false
#   depends_on            = [azurerm_app_service_environment_v3.ase, azurerm_private_dns_zone.privateDnsZone]
# }

# resource "azurerm_private_dns_a_record" "privateDnsZoneName_all" {
#   name                = "*"
#   zone_name           = azurerm_private_dns_zone.privateDnsZone.name
#   resource_group_name = azurerm_resource_group.aserg.name
#   ttl                 = 3600
#   records             = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
#   depends_on          = [azurerm_private_dns_zone.privateDnsZone]
# }

# resource "azurerm_private_dns_a_record" "privateDnsZoneName_scm" {
#   name                = "*.scm"
#   zone_name           = azurerm_private_dns_zone.privateDnsZone.name
#   resource_group_name = azurerm_resource_group.aserg.name
#   ttl                 = 3600
#   records             = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
#   depends_on          = [azurerm_private_dns_zone.privateDnsZone]
# }

# resource "azurerm_private_dns_a_record" "privateDnsZoneName_Amp" {
#   name                = "@"
#   zone_name           = azurerm_private_dns_zone.privateDnsZone.name
#   resource_group_name = azurerm_resource_group.aserg.name
#   ttl                 = 3600
#   records             = azurerm_app_service_environment_v3.ase.internal_inbound_ip_addresses
#   depends_on          = [azurerm_private_dns_zone.privateDnsZone]
# }

