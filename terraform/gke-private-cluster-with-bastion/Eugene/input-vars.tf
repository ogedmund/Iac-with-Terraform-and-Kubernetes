variable "project_id" {
  description = "GCP project id"
}

variable "region" {
  description = "GCP project location"
}

variable "cluster_subnets" {
  description = "IP ranges for cluster nodes, pods and services"
  type = object({
    gke_node_cidr   = string
    gke_master_cidr = string
    gke_pods_cidr   = string
    gke_svc_cidr    = string
  })
}

variable "bastion_startup_script" {
  description = "Startup script for bastion host (jumpbox)"
  type        = string
}

variable "service_account_roles" {
  description = "List of roles to be assigned to the bastion service account"
  type        = list(string)
}