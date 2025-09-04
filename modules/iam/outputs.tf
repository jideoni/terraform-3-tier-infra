output "role_arn" {
  value = aws_iam_role.app_ec2_access_s3_and_ssm.arn
}

output "instance_profile" {
  value = aws_iam_instance_profile.app_ec2_instance_profile.name
}

output "cloudtrail_bucket_policy" {
  value = aws_s3_bucket_policy.cloudtrail_bucket_policy
}
