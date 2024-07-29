resource "google_compute_instance" "bastion" {
  name         = "private-cluster-bastion"
  machine_type = "t2a-standard-1"
  zone         = "${var.region}-a"
  boot_disk {
    initialize_params {
      image = "Debian GNU/Linux 12 (bookwork)"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
  }
  metadata_startup_script = var.bastion_startup_script
}

# Firewall rules for bastion host
resource "google_compute_firewall" "allow_bastion_ssh" {
  name    = "private-cluster-allow-bastion-ssh"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "allow_http_https_rdp" {
  name    = "private-cluster-allow-ext-conn"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3389"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow_http_https_rdp"]
}

# Service accounts for bastion host
resource "google_service_account" "bastion_sa" {
  account_id   = "bastion-sa"
  display_name = "Bastion Service Account"
}
resource "google_project_iam_member" "bastion_sa_roles" {
  for_each = toset(var.service_account_roles)
  project  = var.project_id
  member   = "serviceAccount:${google_service_account.bastion_sa.email}"
  role     = each.value
}