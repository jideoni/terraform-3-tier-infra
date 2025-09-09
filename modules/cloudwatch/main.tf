resource "aws_cloudwatch_metric_alarm" "app_asg_cpu_alarm" {
  alarm_name          = "${var.infra_env}-app_asg_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 120
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.app_asg_name
  }

  alarm_description = "This metric monitors ec2 cpu utilization in app ASG"
  alarm_actions     = [var.app_asg_policy_arn, var.cloudwatch_sns_arn]
}

resource "aws_cloudwatch_metric_alarm" "web_asg_cpu_alarm" {
  alarm_name          = "${var.infra_env}-web_asg_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 120
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }

  alarm_description = "This metric monitors ec2 cpu utilization in web ASG"
  alarm_actions     = [var.web_asg_policy_arn, var.cloudwatch_sns_arn]
}
