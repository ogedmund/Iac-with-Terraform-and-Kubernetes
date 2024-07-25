variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# GKE single zone cluster
data "google_container_engine_versions" "gke_versions" {
  location       = var.region
  version_prefix = "1.27."
}

resource "google_container_cluster" "default" {
  name               = "gke-standard-single-zone"
  location           = "${var.region}-a"
  initial_node_count = var.gke_num_nodes

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  deletion_protection = false
}