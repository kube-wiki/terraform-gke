# terraform-gke

This will create a complete Kubernetes cluster on GKE bootstrapped with [helm](https://helm.sh/). This will also be installed by default:
- [cert-manager](https://github.com/kubernetes/charts/tree/master/stable/cert-manager)
- [nginx-ingress](https://github.com/kubernetes/charts/tree/master/stable/nginx-ingress)

New default version for new clusters can be found at https://cloud.google.com/kubernetes-engine/release-notes

### First enable Kubernetes Engine API and Compute Engine API and then proceed with
```
gcloud auth application-default login
```

### Init
```
terraform init
```

### Setup new cluster (prompted)

```
terraform apply
```

### Setup new cluster (pre-defined)

```
terraform apply \
  -var 'zone=europe-north1-a' \
  -var 'machine_type=n1-standard-1' \
  -var 'node_count=3' \
  -var 'disk_size_gb=50' \
  -var 'cluster_name=bumblebee'
```