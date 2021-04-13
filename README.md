# GKE-project

Repo for term project using Google Kubernetes Engine (GKE) Cluster and Service Mesh-istio

## Set up Istio

1. Create `istio-system` namespace

    ```bash
    kubectl create ns istio-system
    ```

2. Deploy istio helm chart

    ```bash
    helm install istio helm/istio -n istio-system
    ```

3. Set up networking / routing

    ```bash
    kubectl apply -f helm/app/networking
    ```
