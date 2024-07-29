variable "project_id" {
  description = "GCP project id"
  default = "cn8001-iac-kubernetes-terra"
}

variable "region" {
  description = "GCP project location"
  default = "us-central1"
}

#variable "cluster_subnets" {
  #description = "IP ranges for cluster nodes, pods and services"
  #type = object({
    #gke_node_cidr   = string
    #gke_master_cidr = string
   # gke_pods_cidr   = string
  #  gke_svc_cidr    = string
 # })
#}

variable "bastion_startup_script" {
  description = "Startup script for bastion host (jumpbox)"
  type        = string
  default = <<-EOT
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -yq git
EOT
}

variable "service_account_roles" {
  description = "List of roles to be assigned to the bastion service account"
  type        = list(string)
  default = [
  "roles/logging.logWriter",
  "roles/monitoring.metricWriter",
  "roles/monitoring.viewer",
  "roles/compute.osLogin",
  "roles/compute.admin",
  "roles/iam.serviceAccountUser",
  "roles/container.admin",
  "roles/container.clusterAdmin",
  "roles/compute.osAdminLogin"
]
}