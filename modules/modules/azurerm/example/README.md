<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: (Required) The Azure region where the resource should be created

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: (Required) The name of the storage account

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: (Required) The name of the resource group

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier)

Description: (Optional) Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`.

Type: `string`

Default: `"Hot"`

### <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind)

Description: (Optional) The storage account kind: `Storage` or `StorageV2`.

Type: `string`

Default: `"StorageV2"`

### <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type)

Description: (Optional) The storage account replication / redundancy type.  Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`.

Type: `string`

Default: `"LRS"`

### <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier)

Description: (Optional) The storage account tier: `Standard` or `Premium`.

Type: `string`

Default: `"Standard"`

## Outputs

The following outputs are exported:

### <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string)

Description: The primary connection string for the storage account
<!-- END_TF_DOCS -->
