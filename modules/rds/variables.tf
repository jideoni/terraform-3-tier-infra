variable "region" {
  type    = string
  default = "ca-central-1"
}
variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "ruby-dev"
}

variable "rds_name" {
  type        = string
  description = "rds-name"
  default     = "ruby_dev_db"
}

variable "subnet_group_name" {
  type        = string
  description = "Ruby DB subnet group"
  default     = "ruby-db subnet group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the RDS subnet group"
}

variable "azs" {
  type    = list(string)
  default = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}

variable "engine_version" {
  type    = string
  default = "8.0.mysql_aurora.3.08.2"
  #default = "5.7.mysql_aurora.2.03.2"
}

variable "backup_retention_period" {
  type    = number
  default = 5
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "cluster_identifier" {
  type    = string
  default = "aurora-db-cluster-dev"
}


variable "engine" {
  type    = string
  default = "aurora-mysql"
}

variable "db_sg" {}
variable "key_arn" {}
