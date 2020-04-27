# Terraform Version
terraform {
  required_version = ">= 0.12"
}

# DynamoDB table for lock info storage
resource "aws_dynamodb_table" "terraform_lock" {
  name           = var.dynamodb_table
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
}

# S3 bucket for storing terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
      "arn:aws:s3:::${var.bucket_name}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.aws_account_id}:root",
      ]
    }
  }
}

