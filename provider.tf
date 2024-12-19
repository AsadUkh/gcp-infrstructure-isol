provider "google" {
  project = var.project_id
  region  = var.primary_region
}

provider "google-beta" {
  project = var.project_id
  region  = var.primary_region
}



# provider "google" {
#   #   impersonate_service_account = "project-factory@mtech-cloudservices-prj.iam.gserviceaccount.com"
#   project = var.project_id
# }