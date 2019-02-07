#!/bin/bash

gcloud beta config set project $3

# https://cloud.google.com/sdk/gcloud/reference/container/clusters/get-credentials

gcloud beta container clusters get-credentials $1 \
    --region $2 \
    --project $3

kubectl create ns tiller
kubectl create -f ./local-exec/setup.yaml

helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

helm init \
	--service-account tiller \
	--tiller-namespace tiller \
	--wait

# Install ingress
helm fetch --version 0.30.0 stable/nginx-ingress --untar
helm install \
    --namespace nginx-ingress \
    --tiller-namespace tiller \
    --set controller.service.loadBalancerIP=$4 \
    -f nginx-ingress/values.yaml \
    -f ./scripts/nginx-ingress-values.yaml \
    --name nginx-ingress \
    ./nginx-ingress
rm -rf nginx-ingress

helm install \
	--namespace cert-manager \
	--tiller-namespace tiller \
	--name cert-manager \
	--version v0.4.1 \
	stable/cert-manager

kubectl apply -f ./scripts/cluster-issuer-staging.yaml

# Install Concourse CI
#helm install \
#    --namespace concourse-ci \
#    --tiller-namespace tiller \
#    --name concourse-ci \
#    stable/concourse

# Install phpMyAdmin
#helm install \
#    --namespace phpmyadmin \
#    --tiller-namespace tiller \
#    --name phpmyadmin \
#    --version 1.3.0 \
#    stable/phpmyadmin

# Install Prometheus
#helm fetch --version 7.4.1 stable/prometheus --untar
#helm install \
#    --namespace prometheus \
#    --tiller-namespace tiller \
#    -f prometheus/values.yaml \
#    -f ./scripts/prometheus.yaml \
#    --name prometheus \
#    ./prometheus
#rm -rf prometheus