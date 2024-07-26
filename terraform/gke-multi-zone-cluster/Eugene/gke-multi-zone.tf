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

# GKE multi-zone cluster
data "google_container_engine_versions" "gke_versions" {
  location = var.region
}

resource "google_container_cluster" "primary" {
  name               = "gke-standard-multi-zone"
  location           = var.region
  node_locations     = ["${var.region}-b", "${var.region}-c"]
  initial_node_count = var.gke_num_nodes

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  deletion_protection = false
}