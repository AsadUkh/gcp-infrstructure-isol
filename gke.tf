
data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }

module "proc-c1" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "prod-c1"
  region                     = var.primary_region
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = module.vpc.network_name
  subnetwork                 = local.subnet_01
  ip_range_pods              = "${local.subnet_01}-pods"
  ip_range_services          = "${local.subnet_01}-services"
  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  dns_cache                  = false
  node_metadata              = "GKE_METADATA"

  node_pools = [
    {
      name                   = "default-node-pool"
      machine_type           = "e2-medium"
      node_locations         = "us-central1-b,us-central1-c"
      min_count              = 1
      max_count              = 3
      local_ssd_count        = 0
      spot                   = false
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      enable_gcfs            = false
      enable_gvnic           = false
      logging_variant        = "DEFAULT"
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      #   service_account    = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 1

    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}




module "proc-e4" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "prod-e4"
  region                     = var.secondary_region
  zones                      = ["us-east4-a", "us-east4-b", "us-east4-c"]
  network                    = module.vpc.network_name
  subnetwork                 = local.subnet_02
  ip_range_pods              = "${local.subnet_02}-pods"
  ip_range_services          = "${local.subnet_02}-services"
  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  dns_cache                  = false
  node_metadata              = "GKE_METADATA"

  node_pools = [
    {
      name                   = "default-node-pool"
      machine_type           = "e2-medium"
      node_locations         = "us-east4-b,us-east4-c"
      min_count              = 1
      max_count              = 3
      local_ssd_count        = 0
      spot                   = false
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      enable_gcfs            = false
      enable_gvnic           = false
      logging_variant        = "DEFAULT"
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      #   service_account    = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 1

    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}