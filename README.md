# GKE-project
Repo for term project using Google Kubernetes Engine (GKE) Cluster and Service Mesh-istio

Project Structure:
```
.
├── README.md
├── helm
│   ├── app
│   └── istio
└── terraform
    ├── cloudsql
    ├── gke
    └── helm
```

Project covers:
- Automation
- Security
- Proxy
- mTLS
- Open Telemetry

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