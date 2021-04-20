variable "project_id" {
  type = string
  default = "corded-terrain-309700" # "xzhang-csye7125-term-proj"
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "zone_name" {
  type = string
  default = "gke-zone" # "gke-prod-xinyuzhang-me"
}

variable "dns_record_name" {
  type = string
  default = "gke.prod.bh7cw.me." # "gke.prod.xinyuzhang.me."
}