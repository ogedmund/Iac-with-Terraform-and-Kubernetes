# GKE Private Cluster
resource "google_container_cluster" "default" {
  name                = "gke-private-cluster"
  location            = var.region
  initial_node_count  = 2
  deletion_protection = false

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-subnet"
    services_secondary_range_name = "services-subnet"
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.100.100.0/28"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.10.0.2/32"
    }
  }
  default_max_pods_per_node = 110
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  depends_on         = [google_compute_subnetwork.subnet, ]
}