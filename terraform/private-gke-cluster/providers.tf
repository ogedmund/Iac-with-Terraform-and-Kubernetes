terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "google" {
  region  = "us-central1"
  project = "cn8001-k8s-terraform"
  zone    = "us-central1-a"
}