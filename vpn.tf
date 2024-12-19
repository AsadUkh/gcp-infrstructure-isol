# # # Create the external VPN Gateway in the correct region
# # resource "google_compute_vpn_gateway" "vpn_gateway_c1" {
# #   name    = "vpn-gateway"
# #   network = "projects/${var.project_id}/global/networks/${module.vpc.network_name}"
# #   region  = var.primary_region
# # }

# # # Create an external IP for the VPN Gateway
# # resource "google_compute_address" "vpn_gateway_ip" {
# #   name   = "vpn-gateway-ip"
# #   region = var.primary_region
# # }

# # # Create the VPN Tunnel with proper self_link reference
# # resource "google_compute_vpn_tunnel" "vpn_tunnel" {
# #   name                    = "vpn-tunnel"
# #   region                  = var.primary_region
# #   vpn_gateway             = google_compute_vpn_gateway.vpn_gateway_c1.self_link # Correct reference to VPN Gateway's self_link
# #   peer_ip                 = "182.188.235.41"                                    # Public IP of your on-prem or remote VPN device
# #   shared_secret           = "sharedsecret"                                      # Shared secret for VPN connection
# #   ike_version             = 2                                                   # Use IKE version 2
# #   local_traffic_selector  = ["10.10.0.0/16"]                                    # IP range in your VPC you want to access
# #   remote_traffic_selector = ["182.188.235.41/32"]                               # IP range for your laptop (e.g., 192.168.x.x/32)
# # }

# # # Firewall rule to allow traffic from your laptop's VPN IP range to your VPC
# # resource "google_compute_firewall" "allow_vpn_traffic" {
# #   name    = "allow-vpn-traffic"
# #   network = "projects/${var.project_id}/global/networks/${module.vpc.network_name}"
# #   allow {
# #     protocol = "tcp"
# #     ports    = ["80", "443"] # Adjust based on your service ports
# #   }
# #   source_ranges = ["182.188.235.41/32"] # e.g., "192.168.x.x/32"
# # }


# module "vpn-prod-internal" {
#   source  = "terraform-google-modules/vpn/google"
#   version = "~> 1.2.0"

#   project_id         = var.project_id
#   network            = module.vpc.network_name
#   region             = var.primary_region
#   gateway_name       = "vpn-prod-internal"
#   tunnel_name_prefix = "vpn-tn-prod-internal"
#   shared_secret      = "secrets"
#   tunnel_count       = 1
#   peer_ips           = ["182.188.235.41"]

#   route_priority = 1000
#   remote_subnet  = ["182.188.235.41/32"]
# }

