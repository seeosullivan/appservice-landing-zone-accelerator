# ase

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.15.1, <4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_environment_v3.ase](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_environment_v3) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name to assign to the App Service Environment | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group for the ASE | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to use for the App Service Environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_suffix"></a> [dns\_suffix](#output\_dns\_suffix) | DNS suffix of the App Service Environment(v3). |
| <a name="output_id"></a> [id](#output\_id) | ID of the App Service Environment(v3). |
| <a name="output_name"></a> [name](#output\_name) | Name of the App Service Environment(v3). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
