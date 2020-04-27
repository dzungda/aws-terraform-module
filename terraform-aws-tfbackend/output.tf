output "bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table" {
  value = aws_dynamodb_table.terraform_lock.id
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_lock.arn
}

