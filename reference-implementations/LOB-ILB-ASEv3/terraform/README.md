# App Service Landing Zone Accelerator - Terraform Implementation Guide

## Table of Contents

- [App Service Landing Zone Accelerator - Terraform Implementation Guide](#app-service-landing-zone-accelerator---terraform-implementation-guide)
  - [Table of Contents](#table-of-contents)
  - [Pre-requisites](#pre-requisites)
  - [:rocket: Getting started](#rocket-getting-started)
    - [Setting up your environment](#setting-up-your-environment)
      - [Configure Terraform](#configure-terraform)
      - [Configure Remote Storage Account](#configure-remote-storage-account)
    - [Deploy the App Service Landing Zone](#deploy-the-app-service-landing-zone)
      - [Configure Terraform Remote State](#configure-terraform-remote-state)
      - [Provide Parameters Required for Deployment](#provide-parameters-required-for-deployment)
      - [Deploy](#deploy)
  - [Terraform Overview](#terraform-overview)

## Pre-requisites

1. [Terraform](#configure-terraform)
1. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
1. Azure Subscription

## :rocket: Getting started

### Setting up your environment

#### Configure Terraform

If you haven't already done so, configure Terraform using one of the following options:

* [Configure Terraform in Azure Cloud Shell with Bash](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash)
* [Configure Terraform in Azure Cloud Shell with PowerShell](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-powershell)
* [Configure Terraform in Windows with Bash](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash)
* [Configure Terraform in Windows with PowerShell](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-windows-powershell)

#### Configure Remote Storage Account

Before you use Azure Storage as a backend, you must create a storage account.
Run the following commands or configuration to create an Azure storage account and container:

Powershell

```powershell

$RESOURCE_GROUP_NAME='tfstate'
$STORAGE_ACCOUNT_NAME="tfstate$(Get-Random)"
$CONTAINER_NAME='tfstate'

# Create resource group
New-AzResourceGroup -Name $RESOURCE_GROUP_NAME -Location eastus

# Create storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME -SkuName Standard_LRS -Location eastus -AllowBlobPublicAccess $true

# Create blob container
New-AzStorageContainer -Name $CONTAINER_NAME -Context $storageAccount.context -Permission blob

```

Alternatively, the [Terraform Dependencies](../../../.github/workflows/terraform-dependencies.yml) actions workflow can provision the Terraform remote state storage account and container. Customize the deployment by updating the `environment variables` on lines 6-11:

```yaml
env:
  location: 'westus2'
  resource_prefix: "backend-appsrvc"
  environment: "dev"
  suffix: "001"
  container_name: "tfstate"
```

For additional reading around remote state:

* [MS Doc: Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
* [TF Doc: AzureRM Provider Configuration Documentation](https://www.terraform.io/language/settings/backends/azurerm)

### Deploy the App Service Landing Zone

#### Configure Terraform Remote State

To configure your Terraform deployment to use the newly provisioned storage account and container, edit the [`./backend.tf`](./backend.tf) file at lines 8-12 as below:

```hcl
  backend "azurerm" {
    resource_group_name  = "my-rg-name"
    storage_account_name = "mystorageaccountname"
    container_name       = "tfstate"
    key                  = "myapp/terraform.tfstate"
  }
```

* `resource_group_name`: Name of the Azure Resource Group that the storage account resides in.
* `storage_account_name`: Name of the Azure Storage Account to be used to hold remote state.
* `container_name`: Name of the Azure Storage Account Blob Container to store remote state.
* `key`: Path and filename for the remote state file to be placed in the Storage Account Container. If the state file does not exist in this path, Terraform will automatically generate one for you.

#### Provide Parameters Required for Deployment

As you configured the backend remote state with your live Azure infrastructure resource values, you must also provide them for your deployment.

1. Review the available variables with their descriptions and default values in the [variables.tf](./variables.tf) file.
2. Provide any custom values to the defined variables by creating a `terraform.tfvars` file in this direcotry (`reference-implementations/LOB-ILB-ASEv3/terraform/terraform.tfvars`)
    * [TF Docs: Variable Definitions (.tfvars) Files](https://www.terraform.io/language/values/variables#variable-definitions-tfvars-files)

#### Deploy

1. Navigate to the Terraform directory `reference-implementations/LOB-ILB-ASEv3/terraform`
1. Initialize Terraform to install `required_providers` specified within the `backend.tf` and to initialize the backend remote state
    * to run locally without the remote state, comment out the `backend "azurerm"` block in `backend.tf` (lines 8-13)

    ```bash
    terraform init
    ```

1. See the planned Terraform deployment and verify resource values

    ```bash
    terraform plan
    ```

1. Deploy

    ```bash
    terraform apply
    ```

## Terraform Overview

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azurecaf"></a> [azurecaf](#module\_azurecaf) | ./modules/azurecaf | n/a |
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |
| <a name="module_hubspoke_vnets"></a> [hubspoke\_vnets](#module\_hubspoke\_vnets) | ./modules/hubspoke_vnets | n/a |
| <a name="module_privateDns"></a> [privateDns](#module\_privateDns) | ./modules/private_dns | n/a |
| <a name="module_shared-vms"></a> [shared-vms](#module\_shared-vms) | ./modules/shared | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_environment_v3.ase](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_environment_v3) | resource |
| [azurerm_resource_group.aserg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.networkrg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sharedrg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CICDAgentNameAddressPrefix"></a> [CICDAgentNameAddressPrefix](#input\_CICDAgentNameAddressPrefix) | CIDR prefix to use for Spoke VNet | `string` | `"10.0.2.0/24"` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | (Required) Full Product/Application name which will be used to tag. | `string` | n/a | yes |
| <a name="input_aseAddressPrefix"></a> [aseAddressPrefix](#input\_aseAddressPrefix) | CIDR prefix to use for ASE | `string` | `"10.1.1.0/24"` | no |
| <a name="input_bastionAddressPrefix"></a> [bastionAddressPrefix](#input\_bastionAddressPrefix) | CIDR prefix to use for Hub VNet | `string` | `"10.0.1.0/24"` | no |
| <a name="input_business_criticality"></a> [business\_criticality](#input\_business\_criticality) | (Required) Business impact of the resource or supported workload. | `string` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | (Optional) Top-level division of your company that owns the subscription or workload that the resource belongs to. In smaller organizations, this tag might represent a single corporate or shared top-level organizational element. Defaults to Cloud Ops | `string` | `"Cloud Ops"` | no |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | (Required) Sensitivity of data hosted by this resource. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for which the deployment is being executed | `string` | `"dev"` | no |
| <a name="input_hubVNetNameAddressPrefix"></a> [hubVNetNameAddressPrefix](#input\_hubVNetNameAddressPrefix) | CIDR prefix to use for Hub VNet | `string` | `"10.0.0.0/16"` | no |
| <a name="input_jumpBoxAddressPrefix"></a> [jumpBoxAddressPrefix](#input\_jumpBoxAddressPrefix) | CIDR prefix to use for Jumpbox VNet | `string` | `"10.0.3.0/24"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) location - example: South Central US = southcentralus | `string` | n/a | yes |
| <a name="input_numberOfWorkers"></a> [numberOfWorkers](#input\_numberOfWorkers) | numberOfWorkers for ASE | `number` | `3` | no |
| <a name="input_ops_commitment"></a> [ops\_commitment](#input\_ops\_commitment) | (Optional) Level of operations support provided for this workload or resource. Defaults to 'Baseline Only' | `string` | `"Baseline only"` | no |
| <a name="input_ops_team"></a> [ops\_team](#input\_ops\_team) | (Optional) Team accountable for day-to-day operations. Defaults to 'Cloud Ops' | `string` | `"Cloud Ops"` | no |
| <a name="input_spokeVNetNameAddressPrefix"></a> [spokeVNetNameAddressPrefix](#input\_spokeVNetNameAddressPrefix) | CIDR prefix to use for Spoke VNet | `string` | `"10.1.0.0/16"` | no |
| <a name="input_vmadminPassword"></a> [vmadminPassword](#input\_vmadminPassword) | admin password for the virtual machine (devops agent, jumpbox). If none is provided, will be randomly generated and stored in the Key Vault | `string` | `null` | no |
| <a name="input_vmadminUserName"></a> [vmadminUserName](#input\_vmadminUserName) | admin username for the virtual machine (devops agent, jumpbox) | `string` | `"vmadmin"` | no |
| <a name="input_workerPool"></a> [workerPool](#input\_workerPool) | workerPool for ASE | `number` | `1` | no |
| <a name="input_workloadName"></a> [workloadName](#input\_workloadName) | A short name for the workload being deployed | `string` | `"ase"` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | (Optional) Name of the workload the resource supports. Defaults to 'App Svc Landing Zone Accelerator' | `string` | `"App Svc Landing Zone Accelerator"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion"></a> [bastion](#output\_bastion) | Values from the Bastion module. |
| <a name="output_hubSpokeVnets"></a> [hubSpokeVnets](#output\_hubSpokeVnets) | Values from the HubSpoke VNets module. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->