# Backend terraform module

Terraform module to provision an S3 bucket to store terraform.tfstate file and a DynamoDB table to lock the state file to prevent concurrent modifications and state corruption.

## How to use?

```hcl

module "tfbackend" {
  # root module
  source                  = "https://github.com/dzungda/aws-terraform-module/tree/master/terraform-aws-tfbackend"
  aws_account_id          = ""   # account id of project
  bucket_name             = ""   # S3 bucket name to store tfstate file
  dynamodb_table          = ""   # Define dynamodb table to lock state file
  dynamodb_read_capacity  = ""   # RCU of above dynamodb table
  dynamodb_write_capacity = ""   # WCU of above dynamodb table
}


```

### terraform init 
This will make sure that the state is stored in the bucket and the DynamoDB table will be used to lock the state to prevent concurrent modifications.

### terraform apply
This will create the state bucket and locking table.


## Example

https://github.com/dzungda/tfbackend-terraform

