terraform {
  required_version = ">= 1.0"
}

provider "google" {
  credentials = local.credentials
}

locals {
  credentials = file(var.credentials_file)
}

resource "google_container_cluster" "k8sexample" {
  name               = var.cluster_name
  description        = "k8s demo cluster"
  location           = var.gcp_zone
  project            = var.gcp_project
  initial_node_count = var.initial_node_count
  enable_legacy_abac = "true"


  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  provisioner "local-exec" {
    # Load credentials to local environment so subsequent kubectl commands can be run
    command = <<EOS
      gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.gcp_zone} --project ${var.gcp_project}; 
EOS
  }
}

data "template_file" "kubeconfig" {
  template = "${path.module}/templates/kubeconfig-template.yaml"

  vars = {
    cluster_name    = google_container_cluster.k8sexample.name
    user_name       = google_container_cluster.k8sexample.master_auth[0].username
    user_password   = google_container_cluster.k8sexample.master_auth[0].password
    endpoint        = google_container_cluster.k8sexample.endpoint
    cluster_ca      = google_container_cluster.k8sexample.master_auth[0].cluster_ca_certificate
    client_cert     = google_container_cluster.k8sexample.master_auth[0].client_certificate
    client_cert_key = google_container_cluster.k8sexample.master_auth[0].client_key
  }
}
