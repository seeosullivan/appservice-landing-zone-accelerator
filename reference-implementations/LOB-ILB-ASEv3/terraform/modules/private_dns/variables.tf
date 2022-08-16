variable "private_fqdn" {
  description = "The name of the Private DNS Zone. Must be a valid domain name."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the ASE"
  type        = string
}

variable "target_vnet_id" {
  description = "ID of the virtual network to link to the Private DNS Zone"
}

variable "private_dns_a_records" {
  description = "Map of A records to create"
  type        = map(any)
  default     = {}

}
