output "key_arn" {
  description = "The ARN of WEB SNS topics"
  value       = aws_kms_key.ruby-dev-mykey.arn
}
