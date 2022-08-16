variable "name" {
  type        = string
  description = "Base name for the Shared Resources"
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group for the VNets"
}

variable "location" {
  description = "(Required) location - example: South Central US = southcentralus"
  type        = string
  validation {
    condition     = contains(["eastus", "eastus2", "southcentralus", "westus"], lower(var.location))
    error_message = "Location must be one of the following: eastus, eastus2, southcentralus, westus."
  }
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type    = string
  default = null
}

variable "devOpsVMSubnetId" {
  type = string
}

variable "jumpboxVMSubnetId" {
  type = string
}

variable "bastionSubnetId" {
  type = string
}

variable "tenantId" {
  type = string
}
