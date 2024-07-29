# create VPC
resource "google_compute_network" "vpc" {
  name                    = "private-cluster-network"
  auto_create_subnetworks = false
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "private-cluster-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = "cn8001-k8s-terraform"
  name    = "nat-router"
  network = google_compute_network.vpc.name
  region  = "us-central1"
}

## Create Nat Gateway with module
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = "cn8001-k8s-terraform"
  region     = "us-central1"
  router     = google_compute_router.router.name
  name       = "nat-config"
}