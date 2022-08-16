provider "azurerm" {
  features {}
}

locals {
  // Variables
  resourceSuffix              = "${var.workloadName}-${var.environment}-${var.location}-001"
  networkingResourceGroupName = "rgtf-networking-${local.resourceSuffix}"
  sharedResourceGroupName     = "rgtf-shared-${local.resourceSuffix}"
  aseResourceGroupName        = "rgtf-ase-${local.resourceSuffix}"
}

module "azurecaf" {
  source = "./modules/azurecaf"

  resource_types = [
    "azurerm_resource_group",
    "azurerm_app_service_environment",
    "azurerm_virtual_network",
    "azurerm_subnet",
    "azurerm_bastion_host",
    "azurerm_app_service_plan",
    "azurerm_app_service",
    "azurerm_application_insights",
    "azurerm_mssql_server",
    "azurerm_key_vault",
    "azurerm_storage_account",
    "azurerm_function_app",
    "azurerm_mssql_database",
    "azurerm_linux_virtual_machine"
  ]
  location = var.location

  application_name = var.application_name
  environment      = var.environment

  data_classification  = var.data_classification
  business_criticality = var.business_criticality
  workload_name        = var.workload_name
  business_unit        = var.business_unit
  ops_commitment       = var.ops_commitment
  ops_team             = var.ops_team
}


#########
