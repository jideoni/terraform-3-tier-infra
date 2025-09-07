output "key_arn" {
  description = "ARN of the KMS key"
  value       = aws_kms_key.ruby-dev-mykey.arn
}

output "key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.ruby-dev-mykey.id
}
