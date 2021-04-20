variable "project_id" {
  type = string
  default = "corded-terrain-309700"
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "zone_name" {
  type = string
  default = "gke-zone"
}

variable "dns_record_name" {
  type = string
  default = "gke.prod.bh7cw.me."
}