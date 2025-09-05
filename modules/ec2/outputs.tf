output "int_lb_dns_name" {
  value = aws_lb.internal_lb.dns_name
}

output "ext_lb_dns_name" {
  value = aws_lb.external_lb.dns_name
}

output "app_asg_name" {
  value = aws_autoscaling_group.app_asg.name
}

output "web_asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "app_asg_policy_arn" {
  value = aws_autoscaling_policy.app_asg_scaling_policy.arn
}

output "web_asg_policy_arn" {
  value = aws_autoscaling_policy.web_asg_scaling_policy.arn
}

output "ext_alb_public_ip" {
  value = aws_lb.external_lb.dns_name
}

output "ext_alb_zone_id" {
  value = aws_lb.external_lb.zone_id
}

output "app_asg_arn" {
  value = aws_autoscaling_group.app_asg.arn
}

output "web_asg_arn" {
  value = aws_autoscaling_group.web_asg.arn
}
