# 👋 Introduction

A monorepository containing re-usable terraform modules.

# 🔢 Semantic Versioning and Conventional Commits

All modules **must** follow [Semantic Versioning](https://semver.org/), this ensures that modules can be confidently deployed and consumed and teams are aware of when, or if, there are breaking changes to a module.

We enforce Semantic Versioning by following a subset of [Conventional Commits](https://www.conventionalcommits.org/). Any commits to the `main` branch should follow this standard (including merges from PRs).

| Release Type | Commit Prefix            | Commit Keywords                       | Description                                                                                                                                                           |
| ------------ | ------------------------ | ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `major`      | `fix!`, `docs!`, `feat!` | `BREAKING CHANGE`, `BREAKING CHANGES` | Indicates a breaking change and a major version upgrade. Usually reserved for when the Terraform provider includes breaking changes or a drastic re-write of a module |
| `minor`      | `feat`                   |                                       | Indicates a new feature has been added                                                                                                                                |
| `patch`      | `fix`, `docs`            |                                       | This is usually what you'll want to use. Indicates a patch change to the functionality of a module or documentation change                                            |

Feature branches should ideally contain changes **relating to a single module** and **squash merged** with a **custom merge commit** that follows a conventional commit.
This will ensure that your release module is versioned and released in isolation.

You may also chose to perform a **rebase fast-forward merge**, which will preserve all commits. If going this route, ensure that your commit history is clean and also follows conventional commits to ensure any changed modules will be updated based on the commit message.

# ⚙️ Quick Start

```powershell
# Clone this repository
git clone ...

# Create a new feature branch
git checkout -b feature/add-my-new-module

# Add a new azurerm module called my_module
$moduleName = "my_module"
$moduleFolder = New-Item -ItemType Directory "modules/azurerm/$moduleName"
@{ name = $moduleName; version = "0.0.1" } | ConvertTo-Json | Out-File "$moduleFolder/package.json"

# Scaffold the Terraform files
@( "main.tf", "variables.tf", "outputs.tf", "providers.tf" ) | ForEach-Object { New-Item "$moduleFolder/$_" }

# Write your terraform module...

# Commit your changes and push
# git add ...
git commit -m "fix: add a new module"
git push

# Raise a PR and ensure CI passes
# Wait for approval
# Merge your PR - "fix: add a new module"

# Congratulations! 🎉
# Your module will be tagged and pushed to our private registry in a few minutes
```

# 🏭 Pipelines

![image](https://github.com/user-attachments/assets/751a77fd-831d-44ff-a7d7-dbddd370b5ef)

## Affected

1. Gets all modules
1. Gets each module commits, since the module was last tagged
1. Check commit messages to determine the expected new release
1. Output a `matrix` for any modules that have been affected

## CI

Runs for any affected modules

1. Run `terraform fmt -check`
1. Run `tflint`
1. Run `trivy (tfsec)`
1. Run `terraform test`

## Release

Runs for any affected modules

1. Generate docs using `terraform-docs`
1. Generate `CHANGELOG.md`
1. Updates `package.json` with new version
1. Add new `git tag`

Runs once

1. Performs a commit as `chore(release)` (with affected module tags attached to commit)

## Sandbox Release (PR Only)

Runs for any affected modules

1. Generate an `-rc.xxx` version based on the expected release
1. Publish the `-rc.xxx` version to the sandbox

## Publish

1. Create a new module in Terraform Cloud private registry
1. Add a new version to the module based on the `git tag`
1. Upload the module folder to Terraform Cloud

# 🧪 Writing Tests

Tests are written using the native [terraform test](https://developer.hashicorp.com/terraform/language/tests).

By default, `terraform test` will:

- Run any test files (`<name>.tftest.hcl`) inside a modules `tests` folder.
- Use a local `.tfstate` file
- Automatically run `terraform destroy` after the tests have completed

We supply a simple testing harness per provider (`/modules/<provider>/.tests/setup/main.tf`) that will provision an ephemeral environment to deploy your resources in for testing.

| Provider  | Resources                                                             |
| --------- | --------------------------------------------------------------------- |
| `azurerm` | A random resource group within the `Sandbox` Subscription. |

```powershell
# Run the testing harness
#
# This will provide you with 3 outputs, which can be used for your tests.
#
# run.setup.id                  = A random identifier (8 characters, upper and lower)
# run.setup.resource_group_name = The name of the resource group created to run tests in
# run.setup.location            = The location of the resource group created to run tests in

run "setup" {
  module {
    source = "../.tests/setup"
  }
}

# Create a test that runs a `terraform apply` command
# We supply the necessary `variables` the module requires using
# the outputs from our setup/testing harness and whatever else is required
#
# We then `assert` that a resource defined in the module has the correct name

run "storage_account" {
  command = apply

  variables {
    name = "${lower(run.setup.id)}sta"
    resource_group_name = run.setup.resource_group_name
    location = run.setup.location
  }

  assert {
    condition     = azurerm_storage_account.this.name == "${lower(run.setup.id)}sta"
    error_message = "Storage account did not match expected name ${lower(run.setup.id)}sta"
  }
}
```

## Running tests locally

```powershell
# Go to the module you need to check
cd /modules/<provider>/<module_name>

# Authenticate with Azure
az login

# Use the Sandbox Subscription
az account set --name "Sandbox"

# Run terraform test
terraform init
terraform test
```
