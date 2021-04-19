variable "project_id" {
  type = string
  default = "xzhang-csye7125-term-proj"
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "dns_record_name" {
  type = string
  default = "gke.prod.xinyuzhang.me."
}

variable "istio-ingress-gateway-ip" {
  type = string
}