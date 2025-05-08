# Terraform

**This is predominently designed to be ran against Hashicorp Terraform Cloud**

This `deploy.yaml` template can be used to execute `terraform` plan and apply operations.
It's designed so that a consumer pipeline can specify a dynamic list of environments where to deploy infrastructure.

The first environment does not depend on anything, but all other environments must specify a `dependsOn` value.
This controls the flow of pipeline stages during `terraform apply`.

If the pipeline is trigger via a Pull Request, a summary of the changes will automatically be added as a comment.
Subsequent plans will update the same comment.


## Parameters

This template support various additional parameters to accomodate for various deployment situations, such as manually specifying additional cli options when the `terraform` cli runs. As well as executing azure devops tasks before or after a `plan` or `apply`.

[Refer to the descriptions](deploy.yaml) for each parameter for a detailed description

## Examples

### 01: Folder per environment

When each region/environment is isolated in it's own dedicated folder.

```
.
└── project
    └── cc
        ├── dev
        |   └── main.tf
        ├── stg
        |   └── main.tf
        └── prd
            └── main.tf
```

#### Example

```yaml
pool:
  vmImage: ubuntu-latest

resources:
  repositories:
    - repository: templates
      type: git
      name: project/repository
      ref: main

extends:
  template: deploy.yaml@templates
  parameters:
    token:
      serviceConnectionName: Az Service Connection
      keyVaultName: example-kv
      secretName: token
    environments:
      - name: dev
        azureDevOpsEnvironment: dev
        terraformWorkingDirectory: project/cc/dev

      - name: stg
        dependsOn: dev
        azureDevOpsEnvironment: stg
        terraformWorkingDirectory: project/cc/stg

      - name: prd
        dependsOn: stg
        azureDevOpsEnvironment: prd
        terraformWorkingDirectory: project/cc/prd
```

### 02: Variables per environment

When each region/environment configuration is managed via a `.tfvars` variables file and all `.tf` code is in a single folder.

```
.
└── project
    ├── env
    |    ├── dev.tfvars
    |    ├── stg.tfvars
    |    ├── prd.tfvars
    |    └── pr.tfvars
    └── main.tf
```

#### Example

```yaml
pool:
  vmImage: ubuntu-latest

resources:
  repositories:
    - repository: templates
      type: git
      name: project/repository
      ref: main

extends:
  template: deploy.yaml@templates
  parameters:
    token:
      serviceConnectionName: Az Service Connection
      keyVaultName: example-kv
      secretName: token
    environments:
      - name: dev
        azureDevOpsEnvironment: dev
        terraformWorkingDirectory: project
        terraformCommandOptions: '-var-file="env/dev.tfvars"'

      - name: stg
        dependsOn: dev
        azureDevOpsEnvironment: stg
        terraformWorkingDirectory: project
        terraformCommandOptions: '-var-file="env/stg.tfvars"'

      - name: prd
        dependsOn: stg
        azureDevOpsEnvironment: prd
        terraformWorkingDirectory: project
        terraformCommandOptions: '-var-file="env/prd.tfvars"'
```
