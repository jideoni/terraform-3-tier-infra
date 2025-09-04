resource "aws_cloudtrail" "account_trail" {
  depends_on = [var.cloudtrail_bucket_bucket_policy]

  name                          = "ruby-account-trail"
  s3_bucket_name                = var.cloudtrail_bucket_name
  include_global_service_events = true
  kms_key_id                    = var.key_arn
  enable_log_file_validation    = true
}
