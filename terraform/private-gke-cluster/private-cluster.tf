# Private GKE Cluster
resource "google_container_cluster" "primary" {
  name                     = "private-cluster"
  location                 = "us-central1-a"
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
  remove_default_node_pool = true ## Create the smallest possible default node pool and immediately delete it. 
  initial_node_count       = 1
  deletion_protection      = false

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.13.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.7/32"
      display_name = "net1"
    }
  }
}

# Managed Node Pool with 2 nodes
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = "dev"
    }

    machine_type    = "n1-standard-1"
    preemptible     = true
    service_account = google_service_account.bastion_sa.email

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}