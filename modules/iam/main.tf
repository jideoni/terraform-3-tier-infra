resource "aws_iam_instance_profile" "app_ec2_instance_profile" {
  name = "app_ec2_instance_profile"
  role = aws_iam_role.app_ec2_access_s3_and_ssm.name
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"] #can be assumed by which service?
    }
  }
}

resource "aws_iam_role" "app_ec2_access_s3_and_ssm" {
  name               = "abcd_ruby_app_ec2_access_s3_and_ssm"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# S3 read only
data "aws_iam_policy_document" "allow_access_to_s3_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Describe*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"

      #"s3:GetObjects",
      #"s3:ListBucket",
      #"s3:ListAllMyBuckets"
      #"s3:Describe*",
      #"s3-object-lambda:Get*",
      #"s3-object-lambda:List*"
    ]
    resources = [var.code_bucket_arn]
  }
}

resource "aws_iam_policy" "allow_access_to_s3_policy" {
  name        = "allow_s3_read_only"
  description = "Allow S3 read only"
  policy      = data.aws_iam_policy_document.allow_access_to_s3_policy_document.json
}

# KMS_key
data "aws_iam_policy_document" "allow_to_use_kms_key" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [var.kms_key_arn]
  }
}

resource "aws_iam_policy" "allow_to_use_kms_key_policy" {
  name        = "allow_to_use_kms_key"
  description = "Allow instances to use kms key"
  policy      = data.aws_iam_policy_document.allow_to_use_kms_key.json
}

#attach policies to role
resource "aws_iam_role_policy_attachment" "attachments" {
  for_each   = toset(var.ssm_and_s3_read_only_managed_policies)
  role       = aws_iam_role.app_ec2_access_s3_and_ssm.name
  policy_arn = each.key
}
resource "aws_iam_role_policy_attachment" "kms_attachments" {
  #for_each   = toset(var.ssm_and_s3_read_only_managed_policies)
  role       = aws_iam_role.app_ec2_access_s3_and_ssm.name
  policy_arn = aws_iam_policy.allow_to_use_kms_key_policy.arn
}


data "aws_iam_policy_document" "allow_cloudtrail_policy_document" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [var.cloudtrail_bucket_arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${var.cloudtrail_bucket_arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = var.cloudtrail_bucket_name
  policy = data.aws_iam_policy_document.allow_cloudtrail_policy_document.json
}


#KMS Key policy
data "aws_iam_policy_document" "kms_policy_document" {
  #Grant root user all permissions
  statement {
    sid    = "Enable IAM user permission"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::380255901104:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  #Allow EC2
  statement {
    sid    = "allow ec2 resources"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["arn:aws:ec2:ca-central-1:380255901104:instance/*"]
  }

  #Allow S3
  statement {
    sid    = "allow S3 resources"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [var.code_bucket_arn,
      var.cloudtrail_bucket_arn,
      var.vpc_flow_log_bucket_arn
    ]
  }
}

resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = var.kms_key_arn
  policy = data.aws_iam_policy_document.kms_policy_document.json
}
