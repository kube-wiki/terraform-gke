terraform {
  backend "gcs" {
    bucket  = "kube-wiki-tf-state"
    prefix  = "terraform/state"
    project = "kube-wiki-staging"
  }
}