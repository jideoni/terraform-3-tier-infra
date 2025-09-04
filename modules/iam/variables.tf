variable "region" {
  type    = string
  default = "ca-central-1"
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

variable "code_bucket_arn" {}

variable "cloudtrail_bucket_arn" {}
variable "cloudtrail_bucket_name" {}
