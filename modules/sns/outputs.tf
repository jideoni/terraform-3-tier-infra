output "topics_arn" {
  description = "The ARN of the SNS topics"
  value = {
    for topic in aws_sns_topic.notifications :
    topic.arn => topic.name
  }
}

output "web_topic_arn" {
  description = "The ARN of WEB SNS topics"
  value       = aws_sns_topic.notifications["web"].arn
}

output "app_topic_arn" {
  description = "The ARN of APP SNS topics"
  value       = aws_sns_topic.notifications["app"].arn
}

output "cloudwatch_topic_arn" {
  description = "The ARN of CLOUDWATCH SNS topics"
  value       = aws_sns_topic.cloudwatch_notifications.arn
}
