output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.buckets["bucket-vpc-flow-log"].arn
}

output "code_bucket_arn" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.buckets["bucket-for-code"].arn
}

output "code_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.buckets["bucket-for-code"].id
}

output "cloudtrail_bucket_name" {
  description = "The name of the cloudtrail S3 bucket"
  value       = aws_s3_bucket.buckets["cloudtrail-bucket"].id
}

output "cloudtrail_bucket_arn" {
  description = "The name of the cloudtrail S3 bucket"
  value       = aws_s3_bucket.buckets["cloudtrail-bucket"].arn
}
