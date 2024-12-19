# Local variables for subnet names
locals {
  subnet_01 = "${var.vpc_name}-subnet-${var.primary_region}-private01"
  subnet_02 = "${var.vpc_name}-subnet-${var.secondary_region}-private01"
}

# Module for creating the VPC and secondary ranges
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = var.vpc_name

  # Parent CIDR for the VPC (Large enough for future subnets)
  # Example: 10.0.0.0/12 gives you enough room for a large number of subnets
  # We are allocating multiple /16 subnet ranges under this larger parent CIDR.
  subnets = [
    {
      subnet_name           = local.subnet_01
      subnet_ip             = "10.10.0.0/16" # This subnet fits within 10.0.0.0/12 CIDR
      subnet_region         = var.primary_region
      subnet_private_access = true
      subnet_flow_logs      = true
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = "10.20.0.0/16" # This subnet fits within 10.0.0.0/12 CIDR
      subnet_region         = var.secondary_region
      subnet_private_access = true
      subnet_flow_logs      = true
    }
  ]

  # Defining secondary IP ranges for Pods and Services (to allow scalability)
  secondary_ranges = {
    (local.subnet_01) = [
      {
        range_name    = "${local.subnet_01}-pods"
        ip_cidr_range = "192.168.64.0/18" # Larger CIDR block for pods, can be expanded
      },
      {
        range_name    = "${local.subnet_01}-services"
        ip_cidr_range = "192.168.128.0/20" # Smaller CIDR block for services, can be expanded
      }
    ]
    (local.subnet_02) = [
      {
        range_name    = "${local.subnet_02}-pods"
        ip_cidr_range = "192.168.192.0/18" # Larger CIDR block for pods, can be expanded
      },
      {
        range_name    = "${local.subnet_02}-services"
        ip_cidr_range = "192.169.64.0/20" # Smaller CIDR block for services, can be expanded
      }
    ]
  }

  # Example firewall rule to allow SSH ingress (you can expand these later as needed)
  firewall_rules = [
    {
      name      = "allow-ssh-ingress"
      direction = "INGRESS"
      ranges    = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}
