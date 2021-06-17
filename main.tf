terraform {
  required_version = ">= 1.0"
}

resource "random_pet" "name" {
  prefix = "consul"
  length = 1
}

#Google
module "Cluster_GKE" {
  source       = "./Cluster_GKE"
  cluster_name = "gs-${random_pet.name.id}"
  credentials_file = "/Users/gs/workspaces/hashicorp_example/terraform-examples/GCP/gcp-gs-test-282101.json"
}
