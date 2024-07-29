project_id = "cn8001-iac-kubernetes-terra"
region     = "us-central1"
#gke_master_cidr        = "10.10.100.0/28"
#gke_node_cidr          = "10.10.0.0/16"
#gke_pods_cidr          = "10.10.102.0/24"
#gke_svc_cidr           = "10.10.103.0/24"
bastion_startup_script = <<-EOT
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -yq git
EOT
service_account_roles = [
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