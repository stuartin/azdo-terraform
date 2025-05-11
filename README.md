# azdo-terraform
A collection of pipelines and scripts to make working with Terraform, and Azure DevOps easier.

## Pipelines 🏭

- Easily create a pipeline DAG to execute `terraform plan` or `terraform apply` runs.
- Includes an automated commit on Azure DevOps Repository Pull Requests!

## Modules 📦

- Pipelines to manage a terraform module monorepo
- Follows semantic versioning by using conventional commits 
- Automated CI/CD SDLC
  - `tflint`
  - `tricy`
  - `terraform test`
  - Automated documentation
  - Automated changelog
  - Automated tagging
