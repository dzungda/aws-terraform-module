# terraform-aws-module

#

## Getting started with structuring of Terraform configurations

* `provider.tf` Declaration of providers as aws, gcp...and terraform required version. But this is optional maybe using inside `main.tf`
* `main.tf` - call modules, locals and data-sources to create all resources
* `remote.tf` - Retrieves state data from a Terraform backend. This allows you to use the root-level outputs of one or more Terraform configurations as input data for another configuration.
* `variables.tf` - contains declarations of variables used in `main.tf`
* `outputs.tf` - contains outputs from the resources created in `main.tf`
* `terraform.tfvars` contains valube of variables but should not be used anywhere and must be add to `.gitignore`

#

## Standard Structure Modules

```hcl

Structure of root modules

- modules
         -- tf-backend
                - main.tf
                - provider.tf
                - variable.tf
                - outputs.tf
         -- services
                - main.tf
                - provider.tf
                - variable.tf
                - outputs.tf
         ...
                ...
                
Structure of child modules
				
- <environment: prd, stg, dev>
         -- tf-backend
                - main.tf
                - provider.tf
                - variable.tf
                - terraform.tfvars
                - outputs.tf
         -- <region: (ex: ap-southeast-1)>
                - <services>
                       - main.tf
                       - provider.tf
                       - variable.tf
                       - terraform.tfvars
                       - outputs.tf
                ...
                       ...
         -- global
                - <services>
                       - main.tf
                       - provider.tf
                       - variable.tf
                       - terraform.tfvars
                       - outputs.tf


```

### Example

```hcl

- stg
         -- tf-backend
                - main.tf
                - provider.tf
                - variable.tf
                - terraform.tfvars
                - outputs.tf
         -- ap-southeast-1
                - vpc
                       - main.tf
                       - provider.tf
                       - variable.tf
                       - terraform.tfvars
                       - outputs.tf
         -- global
                - iam
                       - main.tf
                       - provider.tf
                       - variable.tf
                       - terraform.tfvars
                       - outputs.tf

- prd
         -- tf-backend
                - main.tf
                - provider.tf
                - variable.tf
                - terraform.tfvars
                - outputs.tf
         -- ap-southeast-1
                - vpc
                       - main.tf
                       - provider.tf
                       - variable.tf
                       - terraform.tfvars
                       - outputs.tf
         -- global
                - iam
                       - main.tf
                       - provider.tf
                       - variable.tf
                       - terraform.tfvars
                       - outputs.tf

```


