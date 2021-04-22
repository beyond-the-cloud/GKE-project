variable "project_id" {
  type = string
  default = "corded-terrain-309700" # "xzhang-csye7125-term-proj"
}

variable "personal_cidr_blocks" {
  type = set(string)
  default = ["216.180.87.0/24", "209.6.158.0/24"]
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "vpc_cidr" {
  type = string
  default = "10.1.2.0/24"
}

variable "db_tier" {
  type = string
  default = "db-n1-standard-2"
}

variable "db_disk_size" {
  type = number
  default = 10
}

variable "db_username" {
  type = string
  default = "root"
}

variable "db_password" {
  type = string
  default = "MysqlPwd123"
}
