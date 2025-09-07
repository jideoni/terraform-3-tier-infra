# Get the current AWS account ID
data "aws_caller_identity" "current" {}

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
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "allow_access_to_s3_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      /*"s3:Get*",
      "s3:List*",
      "s3:Describe*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"*/

      "s3:GetObjects",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:Describe*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
    ]
    resources = [var.code_bucket_arn]
  }
}

resource "aws_iam_policy" "allow_access_to_s3_policy" {
  name        = "allow_s3_read_only"
  description = "Allow S3 read only"
  policy      = data.aws_iam_policy_document.allow_access_to_s3_policy_document.json
}

# Common KMS Actions (local variable)
locals {
  kms_common_actions = [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:DescribeKey"
  ]
}

# KMS_key
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "allow_to_use_kms_key" {
  statement {
    effect    = "Allow"
    actions   = local.kms_common_actions
    resources = ["*"]

    #resources = [var.kms_key_arn]
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
    sid    = "AllowRootFullAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      #identifiers = ["arn:aws:iam::380255901104:root"]
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  #Allow EC2
  statement {
    sid    = "AllowEC2"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions   = local.kms_common_actions
    resources = ["*"]
  }

  #Allow S3
  statement {
    sid    = "AllowS3"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = local.kms_common_actions
    resources = ["*"]
  }

  #Allow SNS
  statement {
    sid    = "AllowSNS"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = local.kms_common_actions
    resources = ["*"]
  }

  #Allow cloudtrail
  statement {
    sid    = "AllowCloudtrail"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    #actions = local.kms_common_actions
    actions   = ["kms:*"]
    resources = ["*"]
  }

  #Allow ASGs
  statement {
    sid    = "Allow Auto Scaling to use the key"
    effect = "Allow"
    principals {
      type = "AWS"
      #identifiers = ["arn:aws:iam::380255901104:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    actions   = local.kms_common_actions
    resources = ["*"]
  }
  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    actions = [
      "kms:CreateGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = var.kms_key_id
  policy = data.aws_iam_policy_document.kms_policy_document.json
}
