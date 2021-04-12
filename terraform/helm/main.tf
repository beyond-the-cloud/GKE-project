provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# kafka
resource "helm_release" "kafka" {
  name       = "kafka"

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

  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
}

# ingress-controller
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
}

# get ingress controller ip
resource "null_resource" "ingress_controller_ip" {
  provisioner "local-exec" {
    command = "kubectl get svc nginx-ingress-controller -o jsonpath=\"{.status.loadBalancer.ingress[0].ip}\""
  }
}

# cert-manager crds
resource "null_resource" "cert_manager_crds" {
  provisioner "local-exec" {
    command = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager.crds.yaml"
  }
}

# letsencrypt-staging/letsencrypt-prod
data "kubectl_file_documents" "manifests_letsencrypt" {
    content = file("./manifests/letsencrypt-staging.yaml")
    # content = file("./manifests/letsencrypt-prod.yaml")
}
resource "kubectl_manifest" "letsencrypt" {
    count     = length(data.kubectl_file_documents.manifests_letsencrypt.documents)
    yaml_body = element(data.kubectl_file_documents.manifests_letsencrypt.documents, count.index)
}

# cert-manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace = "cert-manager"
  create_namespace = true
  version = "v0.14.1"
}

# multi-app-ingress
data "kubectl_filename_list" "manifests_ingress" {
    pattern = "./manifests/multi-app-ingress.yaml"
}

resource "kubectl_manifest" "ingress" {
    count     = length(data.kubectl_filename_list.manifests_ingress.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests_ingress.matches, count.index))
}

# metrics-server
data "kubectl_filename_list" "manifests_metrics_server" {
    pattern = "./manifests/metrics-server.yaml"
}
resource "kubectl_manifest" "metrics_server" {
    count     = length(data.kubectl_filename_list.manifests_metrics_server.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests_metrics_server.matches, count.index))
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# create monitoring namespace
resource "kubernetes_namespace" "ns_monitoring" {
  metadata {
    name = "monitoring"
  }
}