data "google_container_engine_versions" "versions" {
  zone = "${var.zone}"
}

resource "google_compute_address" "ip" {
  name    = "${var.cluster_name}-ip"
  project = "${var.project}"
}

resource "google_container_cluster" "cluster" {
  provider                  = "google-beta"
  name                      = "${terraform.workspace}"
  project                   = "${var.project}"
  region                    = "${var.region}"
  min_master_version        = "1.11.6-gke.2"
  remove_default_node_pool  = true

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  ip_allocation_policy {
    create_subnetwork = true
  }

  master_auth {
    username = ""
    password = ""
  }

  lifecycle {
    ignore_changes  = [
      "network",
      "node_pool"
    ]
  }

  node_pool {
    name = "default-pool"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }
}

resource "google_container_node_pool" "node_pool_updated" {
  provider            = "google-beta"
  project             = "${var.project}"
  cluster             = "${terraform.workspace}"
  region              = "${var.region}"
  initial_node_count  = 1

  node_config {
    machine_type  = "n1-standard-1"
    disk_size_gb  = 50
    //    disk_type     = "pd-ssd"

    # https://developers.google.com/identity/protocols/googlescopes
    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
      "https://www.googleapis.com/auth/service.management",
      "https://www.googleapis.com/auth/sqlservice.admin"
    ]
  }

  management {
    auto_repair   = true
    auto_upgrade  = false
  }

  autoscaling {
    min_node_count  = 1
    max_node_count  = 3
  }

  provisioner "local-exec" {
    command = "./local-exec/setup.sh ${google_container_cluster.cluster.name} ${var.zone} ${var.project} ${google_compute_address.ip.address}"
  }
}
