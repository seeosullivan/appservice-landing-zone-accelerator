variable "resource_type" {
  type        = string
  description = "(Optional) - describes the type of azure resource you are requesting a name from (eg. azure container registry: azurerm_container_registry). See the Resource Type section"
  default     = ""
}

variable "resource_types" {
  type        = list(string)
  description = "(Optional) - a list of additional resource type should you want to use the same settings for a set of resources"
  default     = []
}

variable "application_name" {
  description = "(Required) Full Product/Application name which will be used to tag."
  type        = string
}

variable "environment" {
  description = "(Required) Numerical representation of the environment"
  type        = string
  validation {
    condition     = contains(["uat", "dev", "prod", "qa"], lower(var.environment))
    error_message = "Environment must be of values uat, dev, qa or prod."
  }
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
  description = "(Required) Name of the workload the resource supports."
  type        = string
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

# -
# - CAF Naming Configuration
# - ---------------------------------------------------------------------------------------------------------------------

variable "separator" {
  type        = string
  description = "(Optional) - defaults to none. The separator character to use between prefixes, resource type, name, suffixes, random character"
  default     = ""
}

variable "clean_input" {
  type        = bool
  description = "(Optional) - defaults to true. remove any noncompliant character from the name, suffix or prefix."
  default     = true
}

variable "use_slug" {
  type        = bool
  description = "(Optional) - defaults to true. If a slug should be added to the name - If you put false no slug (the few letters that identify the resource type) will be added to the name."
  default     = true
}

variable "passthrough" {
  type        = bool
  description = "(Optional) - defaults to false. Enables the passthrough mode - in that case only the clean input option is considered and the prefixes, suffixes, random, and are ignored. The resource prefixe is not added either to the resulting string"
  default     = false
}

variable "random_length" {
  type        = number
  default     = 0
  description = "(Optional) - defaults to 0 length of the randomly generated string to append to the name."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "(Optional) - tags to merge with the generated tags."
}
