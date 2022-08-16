#
# Variables for Naming and Tagging
# ---------------------------------------------------------------------------------------------
variable "application_name" {
  description = "(Required) Full Product/Application name which will be used to tag."
  type        = string
}

variable "location" {
  description = "(Required) location - example: South Central US = southcentralus"
  type        = string
  validation {
    condition     = contains(["eastus", "eastus2", "southcentralus", "westus"], lower(var.location))
    error_message = "Location must be one of the following: eastus, eastus2, southcentralus, westus."
  }
}

# -
# - CAF Tagging Variables per the best practices
#   https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging
# - -------------------------------------------------
variable "data_classification" {
  description = "(Required) Sensitivity of data hosted by this resource."
  type        = string
  validation {
    condition     = contains(["non-business", "public", "general", "confidential", "highly confidential"], lower(var.data_classification))
    error_message = "Data Classification must be one of the following: non-business, public, general, confidential, highly confidential."
  }
}

variable "business_criticality" {
  description = "(Required) Business impact of the resource or supported workload."
  type        = string
  validation {
    condition     = contains(["high", "medium", "low", "business unit-critical", "mission-critical"], lower(var.business_criticality))
    error_message = "Business Criticality must be one of the following: high, medium, low, business unit-critical, mission-critical."
  }
}

variable "workload_name" {
  description = "(Optional) Name of the workload the resource supports. Defaults to 'App Svc Landing Zone Accelerator'"
  type        = string
  default     = "App Svc Landing Zone Accelerator"
}

variable "business_unit" {
  description = "(Optional) Top-level division of your company that owns the subscription or workload that the resource belongs to. In smaller organizations, this tag might represent a single corporate or shared top-level organizational element. Defaults to Cloud Ops"
  type        = string
  default     = "Cloud Ops"
}

variable "ops_commitment" {
  description = "(Optional) Level of operations support provided for this workload or resource. Defaults to 'Baseline Only'"
  type        = string
  default     = "Baseline only"
}

variable "ops_team" {
  description = "(Optional) Team accountable for day-to-day operations. Defaults to 'Cloud Ops'"
  type        = string
  default     = "Cloud Ops"
}

# =============================================================================================
variable "workloadName" {
  description = "A short name for the workload being deployed"
  type        = string
  default     = "ase"
}

variable "environment" {
  description = "The environment for which the deployment is being executed"
  type        = string
  default     = "dev"
}

variable "hubVNetNameAddressPrefix" {
  description = "CIDR prefix to use for Hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spokeVNetNameAddressPrefix" {
  description = "CIDR prefix to use for Spoke VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "bastionAddressPrefix" {
  description = "CIDR prefix to use for Hub VNet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "CICDAgentNameAddressPrefix" {
  description = "CIDR prefix to use for Spoke VNet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "jumpBoxAddressPrefix" {
  description = "CIDR prefix to use for Jumpbox VNet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "aseAddressPrefix" {
  description = "CIDR prefix to use for ASE"
  type        = string
  default     = "10.1.1.0/24"
}

variable "numberOfWorkers" {
  description = "numberOfWorkers for ASE"
  type        = number
  default     = 3
}

variable "workerPool" {
  description = "workerPool for ASE"
  type        = number
  default     = 1
}

variable "vmadminUserName" {
  description = "admin username for the virtual machine (devops agent, jumpbox)"
  type        = string
  default     = "vmadmin"
}

variable "vmadminPassword" {
  description = "admin password for the virtual machine (devops agent, jumpbox). If none is provided, will be randomly generated and stored in the Key Vault"
  type        = string
  default     = null
}