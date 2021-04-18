# GKE-project

Repo for term project using Google Kubernetes Engine (GKE) Cluster and Service Mesh-istio

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

3. Update local kubeconfig

    ```bash
    gcloud container clusters get-credentials PROJECT_NAME --region us-east1
    ```

    PROJECT_NAME: `xzhang-csye7125-term-proj-gke` OR `corded-terrain-309700-gke`

4. Create namespace label and secret

    ```bash
    kubectl label namespace default istio-injection=enabled

    kubectl create secret docker-registry docker-hub \
        --docker-username=USERNAME \
        --docker-password=PASSWORD
    ```

5. Install other dependencies

    ```bash
    cd terraform/helm
    terraform plan
    terraform apply
    ```

6. Trigger Jenkins Jobs to deploy `Applications` / `EFK` / `Metrics`

    - efk
    - metrics
    - webapp
    - processor-webapp
    - notifier-webapp

    ```bash
    curl -X POST -L --user bh7cw:11ab7bb1eea6de884033439a0e251af19e https://jenkins.gke.prod.bh7cw.me/job/JOB_NAME/build
    ```

7. Set up networking / routing

    ```bash
    kubectl apply -f helm/app/networking
    ```
