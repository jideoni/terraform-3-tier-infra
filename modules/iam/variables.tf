variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "kms_key_arn" {

}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "ruby-dev"
}

variable "ssm_and_s3_read_only_managed_policies" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

variable "cloudtrail_bucket_name" {} #id

variable "code_bucket_arn" {}
variable "cloudtrail_bucket_arn" {}
variable "vpc_flow_log_bucket_arn" {}

variable "app_topic" {}
variable "web_topic" {}
variable "cloudwatch_topic" {}
variable "cloudtrail_arn" {}
