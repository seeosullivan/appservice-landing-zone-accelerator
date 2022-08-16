variable "name" {
  description = "(Required) Base VNet name, will create hub and spoke pair with this name."
  type        = string
}

variable "subnet_id" {
  description = "(Required) Reference to a subnet in which this Bastion Host has been created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group for the bastion host"
}

variable "location" {
  description = "(Required) location - example: South Central US = southcentralus"
  type        = string
  validation {
    condition     = contains(["eastus", "eastus2", "southcentralus", "westus"], lower(var.location))
    error_message = "Location must be one of the following: eastus, eastus2, southcentralus, westus."
  }
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the Bastion Host."
  type        = map(string)
  default     = {}
}