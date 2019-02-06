terraform {
  backend "gcs" {
    bucket  = "${var.bucket}"
    prefix  = "terraform/state"
    project = "${var.project}"
  }
}