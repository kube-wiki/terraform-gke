#!/bin/bash

gcloud beta container clusters get-credentials $1 \
    --region $2 \
    --project $3

kubectl config current-context
kubectl config use-context $1

kubectl create ns tiller
kubectl create -f ./local-exec/setup.yaml

helm init \
	--service-account tiller \
	--tiller-namespace tiller \
	--wait

helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

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

# Install phpMyAdmin
helm install \
    --namespace phpmyadmin \
    --tiller-namespace tiller \
    --name phpmyadmin \
    --version 1.3.0 \
    stable/phpmyadmin

# Install Prometheus
helm fetch --version 7.4.1 stable/prometheus --untar
helm install \
    --namespace prometheus \
    --tiller-namespace tiller \
    -f prometheus/values.yaml \
    -f ./scripts/prometheus.yaml \
    --name prometheus \
    ./prometheus
rm -rf prometheus

# Install GoCD
helm install \
    --namespace gocd \
    --tiller-namespace tiller \
    --name gocd-app \
    stable/gocd