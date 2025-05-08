provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "xxx"
}

run "setup" {
  module {
    source = "../.tests/setup"
  }
}

run "storage_account" {
  command = apply

  variables {
    name                = "${lower(run.setup.id)}sta"
    resource_group_name = run.setup.resource_group_name
    location            = run.setup.location
  }

  assert {
    condition     = azurerm_storage_account.this.name == "${lower(run.setup.id)}sta"
    error_message = "Storage account did not match expected name ${lower(run.setup.id)}sta"
  }
}
