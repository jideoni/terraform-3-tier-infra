variable "region" {}

variable "vpc_id" {}

variable "infra_env" {}

variable "key_arn" {}

variable "amazon_linux_2023_ami" {
  description = "Amazon Linux 2023 AMI"
  type        = string
  default     = "ami-02018c46119b25ffe"
}

variable "instance_type_web_and_app" {}

variable "instance_profile" {}
variable "instance_profile_arn" {}

variable "app_security_group_id" {}
variable "web_security_group_id" {}

variable "int_lb_security_group_id" {}
variable "ext_lb_security_group_id" {}

variable "subnet_app" {}
variable "subnet_web" {}

variable "all_app_subnets" {}
variable "all_web_subnets" {}

variable "code_bucket_name" {}

variable "app_tier" {
  type    = string
  default = "app"
}
variable "web_tier" {
  type    = string
  default = "web"
}

variable "app_template_name" {
  type    = string
  default = "app_template_name"
}
variable "web_template_name" {
  type    = string
  default = "web_template_name"
}

/*variable "azs" {
  type        = list(string)
  description = "List if AZs"
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}*/

variable "target_tracking_policy" {
  type    = string
  default = "TargetTrackingScaling"
}

variable "app_topic_arn" {}
variable "web_topic_arn" {}
variable "desired_number" {}
variable "max_number" {}
variable "min_number" {}
