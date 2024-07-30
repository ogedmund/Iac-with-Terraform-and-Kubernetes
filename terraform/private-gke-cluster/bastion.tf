# Static IP address within created subnet range for bastion host. This will allow sole access to the private cluster
resource "google_compute_address" "my_internal_ip_addr" {
  project      = "cn8001-k8s-terraform"
  address_type = "INTERNAL"
  region       = "us-central1"
  subnetwork   = google_compute_subnetwork.subnet.name
  name         = "my-ip"
  address      = "10.0.0.7"
  description  = "An internal IP address for the bastion host"
}

# Bastion host [Debian 12 VM instance]
resource "google_compute_instance" "bastion" {
  project      = "cn8001-k8s-terraform"
  zone         = "us-central1-a"
  name         = "jumpbox"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    network_ip = google_compute_address.my_internal_ip_addr.address
  }
}

# Firewall rule to allow SSH into bastion
resource "google_compute_firewall" "rules" {
  project = "cn8001-k8s-terraform"
  name    = "allow-ssh"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Service Account
resource "google_service_account" "bastion_sa" {
  account_id   = "bastion-sa"
  display_name = "Service Account for GKE nodes"
}

# IAP SSH permissions for bastion host
resource "google_project_iam_member" "project" {
  project = "cn8001-k8s-terraform"
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}