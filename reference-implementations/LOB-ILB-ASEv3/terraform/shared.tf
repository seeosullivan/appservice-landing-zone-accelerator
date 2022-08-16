resource "azurerm_resource_group" "sharedrg" {
  name     = "shared-${module.azurecaf.results["azurerm_resource_group"]}"
  location = module.azurecaf.location

  tags = module.azurecaf.tags
}

data "azurerm_client_config" "current" {
}

# Create the DevOps and Jumpbox VMs
module "shared-vms" {
  source            = "./modules/shared"
  name    = module.azurecaf.results["general"]
  resource_group_name = azurerm_resource_group.sharedrg.name
  location          = azurerm_resource_group.sharedrg.location
  admin_username     = var.vmadminUserName
  admin_password     = var.vmadminPassword

  # TODO: Cleanup the subnets getting passed into the module
  # Breakup the module such that the key vaults are a single module, and the devops/jumpbox/bastion vms are created separately
  devOpsVMSubnetId  = module.hubspoke_vnets.hubSubnets["CICDAgent"]
  jumpboxVMSubnetId = module.hubspoke_vnets.hubSubnets["JumpBox"]
  bastionSubnetId   = module.hubspoke_vnets.hubSubnets["AzureBastionSubnet"]
  tenantId          = data.azurerm_client_config.current.tenant_id
}
