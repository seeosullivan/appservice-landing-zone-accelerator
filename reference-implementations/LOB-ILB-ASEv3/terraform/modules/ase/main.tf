variable "name" {
  description = "Name to assign to the App Service Environment"
  type        = string
}


variable "subnet_id" {
  description = "The ID of the subnet to use for the App Service Environment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the ASE"
  type        = string
}

resource "azurerm_app_service_environment_v3" "ase" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  subnet_id                    = var.subnet_id
  internal_load_balancing_mode = "Web, Publishing"
  zone_redundant               = true
}
