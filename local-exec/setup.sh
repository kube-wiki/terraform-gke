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

# Install nginx-ingress
helm install \
    --namespace nginx-ingress \
    --tiller-namespace tiller \
    --set controller.service.loadBalancerIP=$4 \
    -f nginx-ingress/values.yaml \
    -f ./scripts/nginx-ingress-values.yaml \
    --name nginx-ingress \
    --version 0.30.0 \
    stable/nginx-ingress

# Install cert-manager
helm install \
	--namespace cert-manager \
	--tiller-namespace tiller \
	--name cert-manager \
	--version v0.4.1 \
	stable/cert-manager

kubectl apply -f ./scripts/cluster-issuer-staging.yaml
kubectl apply -f ./scripts/cluster-issuer-production.yaml