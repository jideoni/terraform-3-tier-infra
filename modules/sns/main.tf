resource "aws_sns_topic" "notifications" {
  for_each = var.tier

  name         = "${each.key}-sns-topic"
  display_name = "${each.key}-ASG-SNS"

  tags = {
    Name        = "${var.infra_env}-${each.key}-sns-topic"
    Environment = var.infra_env
    Description = each.value
  }
}

resource "aws_sns_topic_policy" "attach_allow_asg_policy" {
  for_each = var.tier

  arn    = aws_sns_topic.notifications[each.key].arn
  policy = data.aws_iam_policy_document.allow_ASG_to_publish[each.key].json

}

resource "aws_sns_topic_subscription" "app_email_target" {
  for_each = var.tier
  #topic_arn = "arn:aws:sns:us-east-1:380255901104:aws_sns_topic.conversion_complete_topic.name"
  topic_arn = aws_sns_topic.notifications[each.key].arn
  protocol  = "email"
  endpoint  = var.your_email
}

#SNS permissions for ASG
data "aws_iam_policy_document" "allow_ASG_to_publish" {
  for_each = aws_sns_topic.notifications

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }

    actions = ["SNS:Publish"]
    #resources = [aws_sns_topic.app_asg_notification.arn, aws_sns_topic.web_asg_notification.arn]
    #resources = ["arn:aws:sns:*"]
    resources = [aws_sns_topic.notifications[each.key].arn]

    #condition {
    #  test     = "ArnLike"
    #  variable = "aws:SourceArn"
    #  values   = [aws_s3_bucket.csv-bucket.arn]
    #}
  }
}



#Cloudwatch SNS setup
resource "aws_sns_topic" "cloudwatch_notifications" {
  name         = "${var.cloudwatch_sns}-sns-topic"
  display_name = "${var.cloudwatch_sns}-ASG-SNS"

  tags = {
    Name        = "${var.infra_env}-${var.cloudwatch_sns}-sns-topic"
    Environment = var.infra_env
    Description = var.cloudwatch_sns
  }
}

resource "aws_sns_topic_policy" "attach_allow_cloudwatch_policy" {
  arn    = aws_sns_topic.cloudwatch_notifications.arn
  policy = data.aws_iam_policy_document.allow_cloudwatch_to_publish.json

}

resource "aws_sns_topic_subscription" "cloudwatch_email_target" {
  #topic_arn = "arn:aws:sns:us-east-1:380255901104:aws_sns_topic.conversion_complete_topic.name"
  topic_arn = aws_sns_topic.cloudwatch_notifications.arn
  protocol  = "email"
  endpoint  = var.your_email
}

#SNS permissions for cloudwatch
data "aws_iam_policy_document" "allow_cloudwatch_to_publish" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions = ["SNS:Publish"]
    #resources = ["arn:aws:sns:*"]
    resources = [aws_sns_topic.cloudwatch_notifications.arn]
  }
}
