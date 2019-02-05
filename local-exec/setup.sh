#!/bin/bash

gcloud beta container clusters get-credentials $1 \
    --region $2 \
    --project $3

kubectl create ns tiller
kubectl create -f ./local-exec/setup.yaml

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