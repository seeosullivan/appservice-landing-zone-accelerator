variable "name" {
  description = "(Required) Base VNet name, will create hub and spoke pair with this name."
  type        = string
}
variable "hub_address_space" {
  description = "(Required) Hub VNet address space, in CIDR notation."
  type        = list(string)
}
variable "spoke_address_space" {
  description = "(Required) Spoke VNet address space, in CIDR notation."
  type        = list(string)
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

variable "hub_subnets" {
  description = "(Optional) Map of subnets to create under the HUB VNet."
  type        = map(any)
  default     = {}
}

variable "spoke_subnets" {
  description = "(Optional) Map of subnets to create under the SPOKE VNet."
  type        = map(any)
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Map of tags to assign to the VNet."
  default     = {}
}