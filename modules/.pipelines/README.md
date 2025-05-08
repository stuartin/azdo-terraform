# Terraform Modules

This `main.yaml` template provides the full SDLC for an azure-devops terraform modules monorepo.

## Example

```yaml
trigger:
  branches:
    include:
      - "*"
  paths:
    include:
      - modules/*
  tags:
    include:
      - "*"

variables:
  - group: TFC_TOKEN_OWNERS
  - name: trunkBranch
    value: $[eq(variables['Build.SourceBranch'], 'refs/heads/master')]
  - name: tag
    value: $[startsWith(variables['Build.SourceBranch'], 'refs/tags/')]

pool:
  vmImage: ubuntu-latest

resources:
  repositories:
    - repository: templates
      type: git
      name: project/repository
      ref: main

extends:
  template: main.yaml@templates
  parameters:
    terraformCloudSandboxToken: $(TFC_TOKEN_OWNERS_SANDBOX)
    terraformCloudProductionToken: $(TFC_TOKEN_OWNERS_PRODUCTION)
```
