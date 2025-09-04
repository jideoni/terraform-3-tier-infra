variable "region" {}

variable "infra_env" {}

variable "tier" {
  type = map(string)

  default = {
    #key = value
    "app" = "app topic"
    "web" = "web topic"
    #"cloudwatch" = "cloudwatch topic"
  }
}

variable "cloudwatch_sns" {
  default = "cloudwatch"
}

variable "your_email" {
  description = "the email address where you want notifications to go"
  type        = string
  default     = "onibabajide345@gmail.com" #your email address here
}
