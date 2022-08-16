data "azurerm_client_config" "current" {}

#key vault
resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-${var.name}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenantId
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
      "Update"
    ]
    secret_permissions = [
      "Get",
      "Set",
      "Delete"
    ]
    storage_permissions = [
      "Get",
      "Set",
      "Update"
    ]
  }
}

#log analytics workspace
resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "law-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#application insights
resource "azurerm_application_insights" "appinsights" {
  name                = "appinsights-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id
}

resource "random_password" "password" {
  count            = var.admin_password == null ? 2 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*?"
}

# Devops agent
module "devopsvm" {
  source             = "../winvm"
  vmname             = "devopsvm"
  location           = var.location
  resource_group_name  = var.resource_group_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password == null ? random_password.password.0.result : var.admin_password
  cidr               = var.devOpsVMSubnetId
  installDevOpsAgent = true
}

# jumpbox
module "jumpboxvm" {
  source             = "../winvm"
  vmname             = "jumpboxvm"
  location           = var.location
  resource_group_name  = var.resource_group_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password == null ? random_password.password.1.result : var.admin_password
  cidr               = var.jumpboxVMSubnetId
  installDevOpsAgent = false
}

# If no VM password is provided, store the generated passwords into the Key Vault as secrets
resource "azurerm_key_vault_secret" "devopsvm_password" {
  count        = var.admin_password == null ? 1 : 0
  name         = module.devopsvm.name
  value        = random_password.password.0.result
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "jumpboxvm_password" {
  count        = var.admin_password == null ? 1 : 0
  name         = module.jumpboxvm.name
  value        = random_password.password.1.result
  key_vault_id = azurerm_key_vault.keyvault.id
}