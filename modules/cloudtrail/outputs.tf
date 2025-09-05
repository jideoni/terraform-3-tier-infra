output "trail_arn" {
  description = "ARN of the cloudtrail"
  value       = aws_cloudtrail.account_trail.arn
}
