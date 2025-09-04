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
    ]
    #resources = ["*"] #which s3 bucket? var.cloudtrail_bucket_arn
    resources = [var.code_bucket_arn]
  }
}

resource "aws_iam_policy" "allow_access_to_s3_policy" {
  name        = "allow_s3_read_only"
  description = "Allow S3 read only"
  policy      = data.aws_iam_policy_document.allow_access_to_s3_policy_document.json
}

/*resource "aws_iam_role_policy_attachment" "attach_allow_access_to_s3_policy_to_role" {
  role = aws_iam_role.app_ec2_access_s3_and_ssm.name
  #policy_arn = aws_iam_policy.allow_access_to_s3_policy.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}*/

#attach policies to role
resource "aws_iam_role_policy_attachment" "attachments" {
  for_each   = toset(var.ssm_and_s3_read_only_managed_policies)
  role       = aws_iam_role.app_ec2_access_s3_and_ssm.name
  policy_arn = each.key
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

    #condition {
    #  test     = "StringEquals"
    #  variable = "aws:SourceArn"
    #  values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/example"]
    #}
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    #resources = ["${aws_s3_bucket.example.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    resources = ["${var.cloudtrail_bucket_arn}/*"]
    /*condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }*/
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = var.cloudtrail_bucket_name
  policy = data.aws_iam_policy_document.allow_cloudtrail_policy_document.json
}
