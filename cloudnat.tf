module "cloud_router_central" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  name    = "my-cloud-router-${var.primary_region}"
  project = var.project_id
  network = module.vpc.network_name
  region  = var.primary_region

  nats = [{
    name                               = "my-nat-gateway-${var.primary_region}"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                     = module.vpc.subnets["us-central1/${local.subnet_01}"].id
        source_ip_ranges_to_nat  = ["ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES", "PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
        secondary_ip_range_names = module.vpc.subnets["us-central1/${local.subnet_01}"].secondary_ip_range[*].range_name
      }
    ]
  }]
}

module "cloud_router_east4" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  name    = "my-cloud-router-${var.secondary_region}"
  project = var.project_id
  network = module.vpc.network_name
  region  = var.secondary_region

  nats = [{
    name                               = "my-nat-gateway-${var.secondary_region}"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                     = module.vpc.subnets["${var.secondary_region}/${local.subnet_02}"].id
        source_ip_ranges_to_nat  = ["ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES", "PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
        secondary_ip_range_names = module.vpc.subnets["${var.secondary_region}/${local.subnet_02}"].secondary_ip_range[*].range_name
      }
    ]
  }]
}