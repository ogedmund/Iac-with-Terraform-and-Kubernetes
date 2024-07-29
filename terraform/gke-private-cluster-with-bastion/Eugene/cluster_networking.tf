# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-private-cluster-network"
  auto_create_subnetworks = false
}

# VPC Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-private-cluster-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/16"

  secondary_ip_range {
    range_name    = "pods-subnet"
    ip_cidr_range = "10.10.102.0/24"
  }

  secondary_ip_range {
    range_name    = "services-subnet"
    ip_cidr_range = "10.10.103.0/24"
  }

  depends_on = [google_compute_network.vpc, ]
}

# Cloud NAT
# External IP address to access the internet for services such as pulling Docker images 
resource "google_compute_address" "external_ip" {
  name         = "private-cluster-global-ip"
  region       = var.region
  address_type = "EXTERNAL"
}
resource "null_resource" "wait_for_ip" {
  depends_on = [google_compute_address.external_ip]
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

# NAT Router
resource "google_compute_router" "nat_router" {
  name    = "private-cluster-nat-router"
  region  = var.region
  network = google_compute_network.vpc.name
}
resource "google_compute_router_nat" "nat" {
  name                               = "router-nat-policy"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.external_ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.external_ip, google_compute_router.nat_router, null_resource.wait_for_ip, ]
}