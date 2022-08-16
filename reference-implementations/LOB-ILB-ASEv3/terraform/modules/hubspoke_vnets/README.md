# hubspoke_vnets

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
| [azurerm_subnet.subnetsHub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnetsSpoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnetHub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.vnetSpoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.peerhubtospoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.peerspoketohub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hub_address_space"></a> [hub\_address\_space](#input\_hub\_address\_space) | (Required) Hub VNet address space, in CIDR notation. | `list(string)` | n/a | yes |
| <a name="input_hub_subnets"></a> [hub\_subnets](#input\_hub\_subnets) | (Optional) Map of subnets to create under the HUB VNet. | `map(any)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) location - example: South Central US = southcentralus | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Base VNet name, will create hub and spoke pair with this name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the resource group for the VNets | `any` | n/a | yes |
| <a name="input_spoke_address_space"></a> [spoke\_address\_space](#input\_spoke\_address\_space) | (Required) Spoke VNet address space, in CIDR notation. | `list(string)` | n/a | yes |
| <a name="input_spoke_subnets"></a> [spoke\_subnets](#input\_spoke\_subnets) | (Optional) Map of subnets to create under the SPOKE VNet. | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the VNet. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hubSubnets"></a> [hubSubnets](#output\_hubSubnets) | IDs of the hub subnets. |
| <a name="output_hubVnetId"></a> [hubVnetId](#output\_hubVnetId) | ID of the hub virtual network. |
| <a name="output_hubVnetName"></a> [hubVnetName](#output\_hubVnetName) | Name of the hub virtual network. |
| <a name="output_spokeSubnets"></a> [spokeSubnets](#output\_spokeSubnets) | IDs of the hub subnets. |
| <a name="output_spokeVnetId"></a> [spokeVnetId](#output\_spokeVnetId) | ID of the spoke virtual network. |
| <a name="output_spokeVnetName"></a> [spokeVnetName](#output\_spokeVnetName) | Name of the spoke virtual network. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
