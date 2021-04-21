provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# istio-system
resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

# istio
resource "helm_release" "istio" {
    name       = "istio"
    chart      = "../../helm/istio"
    namespace  = "istio-system"
}

# istio addons kiali crds
resource "null_resource" "kap-istio-addons-crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../../helm/istio/addons/crds.yaml"
    interpreter = ["/bin/bash", "-c"]
  }
}

# istio addons
resource "null_resource" "kap-istio-addons" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../../helm/istio/addons"
    interpreter = ["/bin/bash", "-c"]
  }
}

# add label to default namespace
resource "null_resource" "label-default-ns" {
  provisioner "local-exec" {
    command = "kubectl label namespace default istio-injection=enabled --overwrite=true"
    interpreter = ["/bin/bash", "-c"]
  }
}

# logging
resource "kubernetes_namespace" "logging" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "logging"
  }
}

# monitoring
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

data "kubernetes_service" "istio_ingressgateway" {
  metadata {
    name = "istio-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [
    helm_release.istio
  ]
}

data "google_dns_managed_zone" "gke_prod_zone" {
  name        = var.zone_name
}

resource "google_dns_record_set" "gke_prod_resource_recordset" {
  name         = var.dns_record_name
  type         = "A"
  ttl          = 60

  managed_zone = data.google_dns_managed_zone.gke_prod_zone.name
  rrdatas      = [data.kubernetes_service.istio_ingressgateway.status.0.load_balancer.0.ingress.0.ip]
}

# kafka
resource "helm_release" "kafka" {
  name       = "kafka"
  depends_on = [
    helm_release.istio
  ]

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"

  values = [
    <<-EOF
    provisioning:
      enabled: true
      topics:
      - name: topstories
        partitions: 2
        replicationFactor: 1
        config:
          max.message.bytes: 64000
          flush.messages: 1
      - name: newstories
        partitions: 2
        replicationFactor: 1
        config:
          max.message.bytes: 64000
          flush.messages: 1
      - name: beststories
        partitions: 2
        replicationFactor: 1
        config:
          max.message.bytes: 64000
          flush.messages: 1
    EOF
  ]
}

# elastic search
resource "helm_release" "elastic_search" {
  name       = "elasticsearch"
  depends_on = [
    helm_release.istio
  ]

  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
}

# # ingress-controller
# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress-controller"

#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "nginx-ingress-controller"

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }
#   set {
#     name  = "controller.service.loadBalancerIP"
#     value = "35.227.22.228"
#   }
# }

# # cert-manager crds
# resource "null_resource" "cert_manager_crds" {
#   provisioner "local-exec" {
#     command = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager.crds.yaml"
#   }
# }

# # letsencrypt-staging/letsencrypt-prod
# data "kubectl_file_documents" "manifests_letsencrypt" {
#     content = file("./manifests/letsencrypt-staging.yaml")
#     # content = file("./manifests/letsencrypt-prod.yaml")
# }
# resource "kubectl_manifest" "letsencrypt" {
#     count     = length(data.kubectl_file_documents.manifests_letsencrypt.documents)
#     yaml_body = element(data.kubectl_file_documents.manifests_letsencrypt.documents, count.index)
# }

# # cert-manager
# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"

#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   namespace = "cert-manager"
#   create_namespace = true
#   version = "v0.14.1"
# }

# # multi-app-ingress
# data "kubectl_filename_list" "manifests_ingress" {
#     pattern = "./manifests/multi-app-ingress.yaml"
# }

# resource "kubectl_manifest" "ingress" {
#     count     = length(data.kubectl_filename_list.manifests_ingress.matches)
#     yaml_body = file(element(data.kubectl_filename_list.manifests_ingress.matches, count.index))
# }

# metrics-server
data "kubectl_filename_list" "manifests_metrics_server" {
    pattern = "./manifests/metrics-server.yaml"
}
resource "kubectl_manifest" "metrics_server" {
    count     = length(data.kubectl_filename_list.manifests_metrics_server.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests_metrics_server.matches, count.index))
}