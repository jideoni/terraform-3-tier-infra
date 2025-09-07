variable "region" {}

variable "infra_env" {}

variable "app_topic" {}
variable "web_topic" {}
variable "cloudwatch_topic" {}

variable "code_bucket_arn" {}
variable "cloudtrail_bucket_arn" {}
variable "vpc_flow_log_bucket_arn" {}
variable "cloudtrail_arn" {}

variable "alias" {
  type    = string
  default = "rubydevkey"
}
