variable "region" {}
#variable "kms_key_arn" {}
variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  #default     = "dev"
}

variable "bucket_name" {
  type = map(number)

  description = "Name of S3 bucket"

  default = {
    #key = value
    "bucket-for-code"     = 1
    "bucket-vpc-flow-log" = 2
    "cloudtrail-bucket"   = 3
  }
}
