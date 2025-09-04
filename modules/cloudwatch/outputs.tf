output "app_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.app_asg_cpu_alarm.arn
}

output "web_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.web_asg_cpu_alarm.arn
}
