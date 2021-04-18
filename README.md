# GKE-project

Repo for term project using Google Kubernetes Engine (GKE) Cluster and Service Mesh-istio

## Set up Istio

1. Run Terraform to setup the whole cluster

    ```bash
    cd terraform/gke
    terraform plan
    terraform apply
    ```

    ```bash
    cd terraform/cloudsql
    terraform plan
    terraform apply
    ```

    ```bash
    cd terraform/helm
    terraform plan
    terraform apply
    ```

2. Set up networking / routing

    ```bash
    kubectl apply -f helm/app/networking
    ```
