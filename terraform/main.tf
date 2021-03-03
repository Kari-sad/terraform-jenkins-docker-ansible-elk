# https://registry.terraform.io/providers/kyma-incubator/kind/latest/docs
terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.7"
    }
  }
}
# Configure the Kind Provider
provider "kind" {}

# Create a cluster
resource "kind_cluster" "default" {
    name = "app"
	node_image = "kindest/node:v1.16.1"
}