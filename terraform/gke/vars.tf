variable "project_id" {
  type = string
  default = "corded-terrain-309700"
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "vpc_cidr" {
  type = string
  default = "10.1.1.0/24"
}

variable "gke_num_nodes" {
  default     = 1
  description = "the number of gke nodes"
}

variable "gke_cidr1" {
  type = string
  default = "216.180.87.0/24"
}

variable "gke_cidr_name1" {
  type = string
  default = "jmac"
}

variable "gke_cidr2" {
  type = string
  default = "209.6.158.0/24"
}

variable "gke_cidr_name2" {
  type = string
  default = "xinyumac"
}

variable "release_channel" {
  type = string
  default = "REGULAR"
}

variable "gke_version" {
  type = string
  default = "1.18.16-gke.302"
}

variable "machine_type" {
  type = string
  default = "e2-standard-4"
}