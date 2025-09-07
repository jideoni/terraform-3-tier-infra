#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "buckets" {
  for_each = var.bucket_name

  bucket = "${each.key}-jyde"

  #buckets will not get destroyed when you run terraform destroy
  #delete manually
  #force_destroy = true

  tags = {
    Name        = "${each.key}-${var.infra_env}"
    Environment = var.infra_env
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = var.bucket_name

  bucket = aws_s3_bucket.buckets[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  for_each = var.bucket_name
  bucket   = aws_s3_bucket.buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "code_bucket_block_public" {
  for_each = var.bucket_name

  bucket = aws_s3_bucket.buckets[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

