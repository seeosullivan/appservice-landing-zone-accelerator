#
# azurecaf-naming
# -------------------------------------------------
# Assists in enforcing naming and tagging standards
# for Azure CAF resources.
#
# Additional information and implementation guidelines:
#  https://github.com/aztfmod/terraform-provider-azurecaf
# -------------------------------------------------

locals {
  # Allow for passing in a single resource type
  resource_types = var.resource_type != "" ? [var.resource_type] : var.resource_types


  # Replicate the minimum suggested tags present in the documentation below:
  # https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging
  additional_tags = merge(
    var.tags,
    {
      WorkloadName = var.workload_name
      DataClassification = var.data_classification
      Criticality = var.business_criticality
      BusinessUnit = var.business_unit
      OpsCommitment = var.ops_commitment
      OpsTeam = var.ops_team
    }
  )

  # Include the "general" resource type in case non-azure related resource, or non-caf-naming supported resource
  fmt_resource_types = contains(local.resource_types, "general") ? local.resource_types : concat(local.resource_types, ["general"])

}

resource "azurecaf_name" "this" {
  resource_types = local.fmt_resource_types

  prefixes = [
    var.application_name
  ]

  suffixes = [
    var.environment
  ]

  # Extra configuration options
  clean_input   = var.clean_input
  use_slug      = var.use_slug
  random_length = var.random_length
  passthrough   = var.passthrough
  separator     = var.separator
}
