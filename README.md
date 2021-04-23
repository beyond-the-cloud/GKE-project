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

6. Set up networking / routing

    ```bash
    kubectl apply -f helm/app/networking
    ```

## Demo Checkpoints

### General

    1. Add configuration to istio-injector config-map to ignore injecting proxy to certain Job/CronJob

    2. Update `newstories`, `topstories`, `beststories` to terminate istio-proxy after finishing work

### GCP

    1. GKE: VPC, Regional, Version: 1.18.x, Public cluster with authorized network, Service account

    2. CloudSQL, only GKE nodes are able to connect to CloudSQL (CloudSQL Auth Proxy: Sidecar, Private IP)

    3. Service Account (Jenkins is using separate service account with minimum permission set)

    4. Jenkins is on GCP, add a DeployAll Multibranch Pipeline to trigger all deployments

### Istio - Traffic Mangement

    - Fine-grain control over what traffic flows where
    - Client side load balancing
    - Resiliency between applications, (automatically retries, circuit breakers, outlier detection, etc.)

    1. Ingress Gateway
    
        Entrypoint of the cluster, only allow traffic from certain hosts. Use along with VitrualService can route requests to designate application Service only. Support TLS/mTLS.

        ```
        kubectl apply -f helm/app/networking
        
        ```
    
    2. Traffic Spliting / Fine-Grained Traffic Control
    
        Route traffic to different destinations with different weight

        ```
        kubectl apply -f helm/app/platform
        locust -f load-test/traffic-splitti
        kubectl apply -f helm/app/demo/traffic-spliting.yaml
        locust -f load-test/traffic-spliting.py
        ```

    3. Content Based Routing

        Route traffic based on uri prefix, headers, and so on

    4. Fault Injection

    5. Circuit Breaking

### Security

    - Runtime identities for every service
    - Policies about which service can communicate
    - Encryption in transit

    1. `mTLS` - Use Kiali to show tls connections

    2. Ingress Gateway HTTPS - Access applicaiton endpoints through HTTPS

### Observablity

    - Visualize what is happening in our deployment

    1. Jaeger / Kiali

    2. Prometheus / Grafana for Istio

    3. Tracing


7. traffic management: 

- ingress gateway
- traffic splitting, v1 & v2, defualt: round robin
  - locust -f load-test/traffic-spliting.py
  - http://localhost:8089/
  - 40, 10, https://gke.prod.bh7cw.me
  - demo/traffic-splitting.yaml
- content based routing
  - k apply -f demo/content-base.yaml
  - locust -f load-test/traffic-spliting.py
  - all go to v2 since no headers

  - locust -f load-test/content-based.py
  - with and without headers
- fault injection -> elastic search and notifier webapp
  - test cluster react to chaos engineering/monkey
  - k apply -f demo/fault-injection.yaml
  - notifier webapp errors in Lens and Kiali
  - k delete -f demo/fault-injection.yaml
- circuit breaker -> set max connection to limit traffic
  - k apply -f demo/ingress-gateway.yaml
  - load: locust -f load-test/traffic-spliting.py
  - k apply -f demo/circuit-breaker.yaml
  - show locust failures
  - k delete -f demo/circuit-breaker.yaml
  - failures stop increacing
9. Security
- mTLS
- kiali
- grafana
- k apply -f security/peer-authentication.yaml
- k apply -f security/destination-rule.yaml
10. observibility