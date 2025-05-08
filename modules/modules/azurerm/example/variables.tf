variable "name" {
  type        = string
  description = "(Required) The name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group"
}

variable "location" {
  type        = string
  description = "(Required) The Azure region where the resource should be created"
}

variable "account_replication_type" {
  type        = string
  description = "(Optional) The storage account replication / redundancy type.  Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`."
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Storage account replication type must be one of 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  }
}

variable "account_kind" {
  type        = string
  description = "(Optional) The storage account kind: `Storage` or `StorageV2`."
  default     = "StorageV2"

  validation {
    condition     = contains(["Storage", "StorageV2"], var.account_kind)
    error_message = "Storage account kind must be 'Storage' or 'StorageV2'."
  }
}

variable "account_tier" {
  type        = string
  description = "(Optional) The storage account tier: `Standard` or `Premium`."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Storage account tier must be 'Standard' or 'Premium'."
  }
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "(Optional) Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."

  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Invalid value for access tier. Valid options are 'Hot' or 'Cool'."
  }
}
