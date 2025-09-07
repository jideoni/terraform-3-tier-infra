#set up the vpc and network components
module "vpc_networking" {
  source     = "../../modules/networking"
  region     = var.region
  bucket_arn = module.create_buckets.vpc_flow_log_bucket_arn
  infra_env  = var.infra_env
  vpc_cidr   = var.vpc_cidr_block
  azs        = var.azs
}

#create s3 buckets
module "create_buckets" {
  source      = "../../modules/s3"
  infra_env   = var.infra_env
  region      = var.region
  kms_key_arn = module.kms.key_arn
}

#Uncomment this section to launch DB
/*module "rds" {
  source = "../../modules/rds"
  key_arn           = module.kms.key_arn

  db_sg = keys(module.vpc_networking.security_groups_created)[4]

  subnet_ids = keys(module.vpc_networking.vpc_db_subnets)
}*/

module "iam" {
  source                  = "../../modules/iam"
  cloudtrail_bucket_arn   = module.create_buckets.cloudtrail_bucket_arn
  cloudtrail_bucket_name  = module.create_buckets.cloudtrail_bucket_name
  code_bucket_arn         = module.create_buckets.code_bucket_arn
  kms_key_arn             = module.kms.key_arn
  kms_key_id              = module.kms.key_id
  vpc_flow_log_bucket_arn = module.create_buckets.vpc_flow_log_bucket_arn
  app_topic               = module.sns.app_topic_arn
  web_topic               = module.sns.web_topic_arn
  cloudwatch_topic        = module.sns.cloudwatch_topic_arn
  cloudtrail_arn          = module.cloudtrail.trail_arn
  app_asg_arn             = module.ec2.app_asg_arn
  web_asg_arn             = module.ec2.web_asg_arn
}

module "kms" {
  source    = "../../modules/kms"
  region    = var.region
  infra_env = var.infra_env
  app_topic = module.sns.app_topic_arn
  web_topic = module.sns.web_topic_arn

  cloudwatch_topic        = module.sns.cloudwatch_topic_arn
  cloudtrail_arn          = module.cloudtrail.trail_arn
  cloudtrail_bucket_arn   = module.create_buckets.cloudtrail_bucket_arn
  code_bucket_arn         = module.create_buckets.code_bucket_arn
  vpc_flow_log_bucket_arn = module.create_buckets.vpc_flow_log_bucket_arn
}

module "ec2" {
  source                    = "../../modules/ec2"
  region                    = var.region
  vpc_id                    = module.vpc_networking.vpc_id
  infra_env                 = var.infra_env
  instance_profile          = module.iam.instance_profile
  instance_profile_arn      = module.iam.instance_profile_arn
  instance_type_web_and_app = var.instance_type_web_and_app
  code_bucket_name          = module.create_buckets.code_bucket_name
  subnet_app                = keys(module.vpc_networking.vpc_private_subnets)[0]
  subnet_web                = keys(module.vpc_networking.vpc_public_subnets)[0]
  app_security_group_id     = module.vpc_networking.app_sg_id
  web_security_group_id     = module.vpc_networking.web_sg_id
  all_app_subnets           = keys(module.vpc_networking.vpc_private_subnets)
  all_web_subnets           = keys(module.vpc_networking.vpc_public_subnets)
  int_lb_security_group_id  = module.vpc_networking.internal_lb_sg_id
  ext_lb_security_group_id  = module.vpc_networking.external_lb_sg_id
  app_topic_arn             = module.sns.app_topic_arn
  web_topic_arn             = module.sns.web_topic_arn
  desired_number            = var.instance_number_asg["desired"]
  max_number                = var.instance_number_asg["max"]
  min_number                = var.instance_number_asg["min"]
  key_arn                   = module.kms.key_arn
}

module "sns" {
  source            = "../../modules/sns"
  region            = var.region
  infra_env         = var.infra_env
  your_email_addres = var.your_email
  key_arn           = module.kms.key_arn
}

module "cloudwatch" {
  source             = "../../modules/cloudwatch"
  region             = var.region
  vpc_id             = module.vpc_networking.vpc_id
  infra_env          = var.infra_env
  app_asg_name       = module.ec2.app_asg_name
  web_asg_name       = module.ec2.web_asg_name
  app_asg_policy_arn = module.ec2.app_asg_policy_arn
  web_asg_policy_arn = module.ec2.web_asg_policy_arn
  cloudwatch_sns_arn = module.sns.cloudwatch_topic_arn
}

module "route53" {
  source                           = "../../modules/route53"
  region                           = var.region
  infra_env                        = var.infra_env
  external_load_balancer_public_ip = module.ec2.ext_alb_public_ip
  external_load_balancer_zone_id   = module.ec2.ext_alb_zone_id
}

module "cloudtrail" {
  source                          = "../../modules/cloudtrail"
  region                          = var.region
  infra_env                       = var.infra_env
  cloudtrail_bucket_name          = module.create_buckets.cloudtrail_bucket_name
  cloudtrail_bucket_bucket_policy = module.iam.cloudtrail_bucket_policy
  key_arn                         = module.kms.key_arn
}
