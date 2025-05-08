terraform {
  required_version = "~> 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "xxx"
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "(Optional) The Azure location where the resource group will be deployed."
}

resource "random_string" "setup" {
  length  = 8
  special = false
}



resource "azurerm_resource_group" "setup" {
  name     = "terraform-test-${random_string.setup.result}-rg"
  location = var.location
}


output "id" {
  value       = random_string.setup.result
  description = "A random identifier (8 characters, upper and lower)"
}

output "resource_group_name" {
  value       = azurerm_resource_group.setup.name
  description = "The name of the resource group created to run tests in"
}

output "location" {
  value       = azurerm_resource_group.setup.location
  description = "The location of the resource group created to run tests in"
}
