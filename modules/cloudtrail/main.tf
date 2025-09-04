resource "aws_cloudtrail" "account_trail" {
  depends_on = [var.cloudtrail_bucket_bucket_policy]

  name           = "ruby-account-trail"
  s3_bucket_name = var.cloudtrail_bucket_name
  #s3_key_prefix                 = "prefix"
  include_global_service_events = true
}
