data "google_compute_network_endpoint_group" "central1b-neg" {
  name    = "ingress-nginx-80-neg-http"
  zone    = "us-central1-b"
  project = var.project_id
}

data "google_compute_network_endpoint_group" "central1c-neg" {
  name    = "ingress-nginx-80-neg-http"
  zone    = "us-central1-c"
  project = var.project_id
}

# data "google_compute_network_endpoint_group" "east4-neg" {
#   name    = "ingress-nginx-80-neg-http"
#   zone    = "us-east4-c"
#   project = var.project_id
# }

# provider "google" {
# #   impersonate_service_account = "project-factory@mtech-cloudservices-prj.iam.gserviceaccount.com"
#   project                     = var.project_id
# }