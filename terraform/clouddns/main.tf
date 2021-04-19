provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_dns_managed_zone" "gke_prod_zone" {
  name        = "gke-prod-xinyuzhang-me"
}

resource "google_dns_record_set" "gke_prod_resource_recordset" {
  managed_zone = data.google_dns_managed_zone.gke_prod_zone.name

  name         = "gke.prod.xinyuzhang.me."
  type         = "A"
  rrdatas      = [var.istio-ingress-gateway-ip]
  ttl          = 60
}
