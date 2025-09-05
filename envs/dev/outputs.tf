#for debugging
output "vpc" {
  description = "VPC id"
  value       = module.vpc_networking.vpc_id
}

output "web_subnets" {
  description = "map of web subnet ids"
  value       = module.vpc_networking.vpc_public_subnets
}

output "app_subnets" {
  description = "map of app subnet ids"
  value       = module.vpc_networking.vpc_private_subnets
}

output "db_subnets" {
  description = "map of db subnet ids"
  value       = module.vpc_networking.vpc_db_subnets
}

output "security_groups" {
  description = "map of SG ids"
  value       = module.vpc_networking.security_groups_created
}

output "ssm_s3_role_arn" {
  value = module.iam.role_arn
}

output "flow_logs_s3_bucket" {
  value = module.create_buckets.vpc_flow_log_bucket_arn
}

output "db_sg" {
  # Get a list of all SG IDs
  value = keys(module.vpc_networking.security_groups_created)[0]
}

output "app_sg" {
  value = module.vpc_networking.app_sg_id
}

output "web_sg" {
  value = module.vpc_networking.web_sg_id
}

output "instance_profile_ssm_s3_access" {
  value = module.iam.instance_profile
}

#output "code_bucket_name" {
#  value = module.s3.code_bucket_name
#}

output "int_lb_dns_name" {
  value = module.ec2.int_lb_dns_name
}

output "ext_lb_dns_name" {
  value = module.ec2.ext_lb_dns_name
}

output "app_sns_arn" {
  value = module.sns.app_topic_arn
}

output "web_sns_arn" {
  value = module.sns.web_topic_arn
}

output "cloudwatch_sns_arn" {
  value = module.sns.cloudwatch_topic_arn
}

/*output "int_lb_security_group" {
  value = [keys(module.vpc_networking.security_groups_created)[3]]
}

output "ext_lb_security_group" {
  value = [keys(module.vpc_networking.security_groups_created)[1]]
}*/

output "internal_lb_sg" {
  description = "Internal ALB SG"
  value       = module.vpc_networking.internal_lb_sg_id
}

output "external_lb_sg" {
  description = "External ALB SG"
  value       = module.vpc_networking.external_lb_sg_id
}
