variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "ruby-dev" #your "app-environment"
}

variable "region" {
  type    = string
  default = "ca-central-1" #your region here
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/17" #your vpc cider block here
}

variable "bucket_name" {
  type = map(number)

  description = "Name of S3 bucket"

  default = {
    #key = value
    "bucket-for-code"     = 1
    "bucket-vpc-flow-log" = 2
  }
}

variable "azs" {
  type        = list(string)
  description = "List if AZs"
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}

variable "instance_number_asg" {
  type = map(number)

  description = "Number of instances in ASG"

  default = {
    #key = value
    "desired" = 2
    "max"     = 3
    "min"     = 2
  }
}
