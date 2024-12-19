# module "vpc" {
#   source  = "terraform-google-modules/network/google"
#   version = "~> 7.0"

#   project_id   = var.project_id
#   network_name = var.vpc_name
#   routing_mode = "REGIONAL"

#   subnets = [
#     {
#       subnet_name              = "subnet-${var.primary_region}-private"
#       subnet_ip                = "10.10.0.0/16"
#       subnet_region            = var.primary_region
#       private_ip_google_access = true
#       secondary_ip_ranges = {
#         pods     = "10.48.0.0/14"
#         services = "10.52.0.0/20"
#       }
#     },
#     {
#       subnet_name              = "subnet-${var.secondary_region}-private"
#       subnet_ip                = "10.20.0.0/16"
#       subnet_region            = var.secondary_region
#       private_ip_google_access = true
#       secondary_ip_ranges = {
#         pods     = "10.56.0.0/14"
#         services = "10.60.0.0/20"
#       }
#     }
#   ]
# }




# module "cloud_nat" {
#   source  = "terraform-google-modules/cloud-router/google"
#   version = "~> 3.0"

#   project_id  = var.project_id
#   region      = var.primary_region
#   network     = module.vpc.network_name
#   router_name = "cloud-nat-router" # Name of the Cloud Router

#   nat_ip_allocate_option = "AUTO_ONLY" # Automatically allocate NAT IPs

#   nat {
#     name                               = "cloud-nat"
#     router_name                        = "cloud-nat-router"
#     region                             = var.primary_region
#     source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   }
# }


# module "cloud_nat_secondary" {
#   source  = "terraform-google-modules/cloud-router/google"
#   version = "~> 1.2"

#   project_id = var.project_id
#   region     = var.secondary_region
#   name       = "cloud-nat-${var.secondary_region}"
#   network    = module.vpc.network_name
#   nat_ips    = null  # Dynamically allocate IPs as needed
# }