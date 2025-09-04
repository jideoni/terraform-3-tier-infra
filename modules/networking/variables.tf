variable "region" {}
variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "tcp" {
  type        = string
  description = "tcp protocol"
  default     = "tcp"
}

variable "icmp" {
  type        = string
  description = "icmp protocol to allow ping"
  default     = "icmp"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range for VPC"
}

variable "internet" {
  type        = string
  description = "Access to all"
  default     = "0.0.0.0/0"
}

variable "bucket_arn" {}

variable "azs" {
  type        = list(string)
  description = "List if AZs"
}

variable "web_subnet_number" {
  type = map(number)

  description = "Map of AZ to a number for public subnets"

  default = {
    #key = value
    "ca-central-1a" = 1
    "ca-central-1b" = 2
    "ca-central-1d" = 3
  }
}

variable "app_subnet_number" {
  type = map(number)

  description = "Map of AZ to a number for private subnets"

  default = {
    #key = value
    "ca-central-1a" = 4
    "ca-central-1b" = 5
    "ca-central-1d" = 6
  }
}

variable "db_subnet_number" {
  type = map(number)

  description = "Map of AZ to a number for private subnets"

  default = {
    #key = value
    "ca-central-1a" = 7
    "ca-central-1b" = 8
    "ca-central-1d" = 9
  }
}

variable "web_route_table" {
  type        = string
  description = "Route table for web tier (internet accessible)"
  default     = "web tier route table"
}

variable "app_route_table" {
  type        = map(number)
  description = "Route table for app tier (not internet accessible)"
  default = {
    #key = value
    "app-rt-1" = 1
    "app-rt-2" = 2
    "app-rt-3" = 3
  }
}

variable "web_eips_name" {
  type = map(number)

  description = "Map of eip to a number"

  default = {
    #key = value
    "web-eip-1" = 1
    "web-eip-2" = 2
    "web-eip-3" = 3
  }
}

variable "security_groups" {
  type = map(string)

  description = "Map of SGs"

  default = {
    #key = value
    "ext-alb-SG" = "allows internet access to external alb"
    "web-SG"     = "allows external alb acccess"
    "int-alb-SG" = "allows web sg acccess"
    "app-SG"     = "allows internal alb acccess"
    "db-SG"      = "allows db sg acccess"
  }
}
