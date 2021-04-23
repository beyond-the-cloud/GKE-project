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

variable "grafana_zone_name" {
  type = string
  default = "grafana-gke" # "grafana"
}

variable "kibana_zone_name" {
  type = string
  default = "kibana-gke" # "kibana"
}

variable "kiali_zone_name" {
  type = string
  default = "kiali-gke" # "kiali"
}

variable "tracing_zone_name" {
  type = string
  default = "tracing-gke" # "tracing"
}

variable "istio_grafana_zone_name" {
  type = string
  default = "istio-grafana-gke" # "istio-grafana"
}