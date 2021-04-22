# GKE-project

Repo for term project using Google Kubernetes Engine (GKE) Cluster and Service Mesh-istio

## Project Structure

    .
    ├── README.md
    ├── helm/
    │   ├── app/
    │   │   ├── demo/
    │   │   ├── networking/
    │   │   ├── platform/
    │   │   └── security/
    │   └── istio/
    │       ├── addons/
    │       ├── charts/
    │       └── values.yaml
    ├── terraform/
    │   ├── cloudsql/
    │   ├── gke/
    │   └── helm/
    └── load-test/
        ├── content-based.py
        └── traffic-spliting.py

## Project covers

1. GCP / GKE
2. Automation
3. Infrastructure as Code
4. Istio
    1. Traffic Management
        1. Ingress Gateway
        2. Traffic Spliting
        3. Content Based Routing
        4. Fault Injection
        5. Circuit Breaking
    2. Observability
        1. Opentelemetry - Jaeger
        2. Kiali
        3. Grafana - Istio
    3. Security
        1. mTLS
        2. CA - cert-manager

## Set up

1. Bring up GKE Cluster

    ```bash
    cd terraform/gke
    terraform plan
    terraform apply
    ```

2. Bring up CloudSQL servers

    ```bash
    cd terraform/cloudsql
    terraform plan
    terraform apply
    ```

3. Create secret

    ```bash
    kubectl create secret docker-registry docker-hub \
        --docker-username=USERNAME \
        --docker-password=PASSWORD
    ```

4. Install other dependencies

    ```bash
    cd terraform/helm
    terraform plan
    terraform apply
    ```

5. Trigger Jenkins Jobs to deploy `EFK` / `Metrics` / `Applications`

    - efk
    - metrics
    - webapp
    - processor-webapp
    - notifier-webapp

    ```bash
    curl -X POST -L --user bh7cw:11ab7bb1eea6de884033439a0e251af19e https://jenkins.gke.prod.bh7cw.me/job/JOB_NAME/build
    ```

6. Set up networking / routing

    ```bash
    kubectl apply -f helm/app/networking
    ```
