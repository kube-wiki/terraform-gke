variable "cluster_name" {
  default = "kube-wiki-staging-cluster"
}

variable "project" {
  default = ""
}

variable "region" {
  default = "europe-north1"
}

variable "zone" {
  default = "a"
}

variable "min_node_count" {
  default = 1
}

variable "max_node_count" {
  default = 3
}

variable "machine_type" {
  default = "n1-standard-2"
}