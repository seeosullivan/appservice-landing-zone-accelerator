# private_dns

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
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_dns_a_records"></a> [private\_dns\_a\_records](#input\_private\_dns\_a\_records) | Map of A records to create | `map(any)` | `{}` | no |
| <a name="input_private_fqdn"></a> [private\_fqdn](#input\_private\_fqdn) | The name of the Private DNS Zone. Must be a valid domain name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group for the ASE | `string` | n/a | yes |
| <a name="input_target_vnet_id"></a> [target\_vnet\_id](#input\_target\_vnet\_id) | ID of the virtual network to link to the Private DNS Zone | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the private DNS zone. |
| <a name="output_name"></a> [name](#output\_name) | Name of the private DNS zone. |
| <a name="output_private_dns_a_records"></a> [private\_dns\_a\_records](#output\_private\_dns\_a\_records) | Map of A records created through this module. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
