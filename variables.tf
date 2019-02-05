variable "project" {
  description = "kube-wiki-staging"
}

variable "cluster_name" {
  description = "kube-wiki Staging"
}

variable "zone" {
  description = "europe-north1-a"
}

variable "node_count" {
  description = 1
}

variable "machine_type" {
  description = "n1-standard-2"
}

variable "disk_size_gb" {
  description = 50
}