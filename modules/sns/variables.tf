variable "region" {}
variable "infra_env" {}
variable "key_arn" {}

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

variable "your_email_addres" {}
