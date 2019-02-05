provider "google" {
  version = "1.19.0"
  project = "${var.project}"
  region  = "${var.region}"
}

provider "google-beta" {
  version = "1.19.0"
  project = "${var.project}"
  region  = "${var.region}"
}