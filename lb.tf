module "classic-gclb" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/dynamic_backends"
  version = "12.0.0"

  name                = "classic-gclb"
  project             = var.project_id
  enable_ipv6         = false
  create_ipv6_address = false
  http_forward        = true
  #   create_http_forward = true

  create_address = false
  address        = google_compute_global_address.external-gclb.address

  load_balancing_scheme = "EXTERNAL"
  firewall_networks     = [module.vpc.network_name]
  firewall_projects     = [var.project_id]

  ssl = false

  https_redirect   = false
  ssl_certificates = []

  #   ssl_policy = google_compute_ssl_policy.ecom-ssl-policy.self_link

  url_map        = google_compute_url_map.gcp_external_classic_urlmap.self_link
  create_url_map = false


  #   security_policy = "https://www.googleapis.com/compute/beta/projects/mtech-ns-ecom-perf/global/securityPolicies/ecom-trans-perf-ca"

  backends = {
    cloud-mass-mcom-perf-be = {
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false
      health_check = {
        request_path = "/MASS/actuator/health"
        port         = "80"
        host         = "cloud-mass.bcom-perf.devops.fds.com"

      }
      log_config = {
        enable      = false
        sample_rate = 1.0
      }
      groups = [
        {
          group           = data.google_compute_network_endpoint_group.central1b-neg.id
          capacity_scaler = 1
          balancing_mode  = "RATE"
          max_rate        = "1.0"
        },
        #   {
        #   group           = data.google_compute_network_endpoint_group.east4-neg.id
        #   capacity_scaler = 1
        #   balancing_mode  = "RATE"
        #   max_rate        = "1.0"
        # }
      ]
      iap_config = {
        enable = false
      }
    },
    grafana-be = {
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false
      health_check = {
        request_path = "/api/health"
        port         = "80"
        host         = "grafana.asadali.ie"

      }
      log_config = {
        enable      = false
        sample_rate = 1.0
      }
      groups = [
        {
          group           = data.google_compute_network_endpoint_group.central1b-neg.id
          capacity_scaler = 1
          balancing_mode  = "RATE"
          max_rate        = "1.0"
        },
        #    {
        #   group           = data.google_compute_network_endpoint_group.east4-neg.id
        #   capacity_scaler = 1
        #   balancing_mode  = "RATE"
        #   max_rate        = "1.0"
        # }
      ]
      iap_config = {
        enable = false
      }
    },
    argocd-be = {
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false
      health_check = {
        request_path = "/healthz?full=true"
        port         = "80"
        host         = "prod-argocd.asadali.ie"

      }
      log_config = {
        enable      = false
        sample_rate = 1.0
      }
      groups = [
        {
          group           = data.google_compute_network_endpoint_group.central1b-neg.id
          capacity_scaler = 1
          balancing_mode  = "RATE"
          max_rate        = "1.0"
        }
      ]
      iap_config = {
        enable = false
      }
    },
    prometheus-be = {
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false
      health_check = {
        request_path = "/-/healthy"
        port         = "80"
        host         = "prometheus.asadali.ie"

      }
      log_config = {
        enable      = false
        sample_rate = 1.0
      }
      groups = [
        {
          group           = data.google_compute_network_endpoint_group.central1b-neg.id
          capacity_scaler = 1
          balancing_mode  = "RATE"
          max_rate        = "1.0"
        },
        #    {
        #   group           = data.google_compute_network_endpoint_group.east4-neg.id
        #   capacity_scaler = 0
        #   balancing_mode  = "RATE"
        #   max_rate        = "1.0"
        # }
      ]
      iap_config = {
        enable = false
      }
    },
    wishlist-be = {
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false
      health_check = {
        request_path = "/"
        port         = "80"
        host         = "wishlist.asadali.ie"

      }
      log_config = {
        enable      = false
        sample_rate = 1.0
      }
      groups = [
        {
          group           = data.google_compute_network_endpoint_group.central1b-neg.id
          capacity_scaler = 1
          balancing_mode  = "RATE"
          max_rate        = "1.0"
        },
        #    {
        #   group           = data.google_compute_network_endpoint_group.east4-neg.id
        #   capacity_scaler = 0
        #   balancing_mode  = "RATE"
        #   max_rate        = "1.0"
        # }
      ]
      iap_config = {
        enable = false
      }
    },

    secure-java21-gsm-api-be = {
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false
      health_check = {
        request_path = "/hello"
        port         = "80"
        host         = "secure-java21-gsm-api.asadali.ie"

      }
      log_config = {
        enable      = false
        sample_rate = 1.0
      }
      groups = [
        {
          group           = data.google_compute_network_endpoint_group.central1b-neg.id
          capacity_scaler = 1
          balancing_mode  = "RATE"
          max_rate        = "1.0"
        },
        #    {
        #   group           = data.google_compute_network_endpoint_group.east4-neg.id
        #   capacity_scaler = 1
        #   balancing_mode  = "RATE"
        #   max_rate        = "1.0"
        # }
      ]
      iap_config = {
        enable = false
      }
    }
  }
}


resource "google_compute_backend_bucket" "gcp-dummy-fail-no-host-header" {
  bucket_name = google_storage_bucket.dummy_backend_bucket.name
  enable_cdn  = false
  name        = "gcp-dummy-fail-no-host-header"
  project     = var.project_id
}

resource "google_compute_url_map" "gcp_external_classic_urlmap" {
  name            = "gcp-classic-gclb"
  description     = "mcom ns perf external url map"
  default_service = google_compute_backend_bucket.gcp-dummy-fail-no-host-header.self_link

  host_rule {
    hosts        = ["cloud-mass.perf.devops.fds.com"]
    path_matcher = "cloud-mass-mcom-perf"
  }

  path_matcher {
    default_service = module.classic-gclb.backend_services["cloud-mass-mcom-perf-be"].self_link
    description     = null
    name            = "cloud-mass-mcom-perf"
  }
  host_rule {
    hosts        = ["grafana.asadali.ie"]
    path_matcher = "grafana"
  }

  path_matcher {
    default_service = module.classic-gclb.backend_services["grafana-be"].self_link
    description     = null
    name            = "grafana"
  }

  host_rule {
    hosts        = ["prod-argocd.asadali.ie"]
    path_matcher = "argocd"
  }

  path_matcher {
    default_service = module.classic-gclb.backend_services["argocd-be"].self_link
    description     = null
    name            = "argocd"
  }

  host_rule {
    hosts        = ["prometheus.asadali.ie"]
    path_matcher = "prometheus"
  }

  path_matcher {
    default_service = module.classic-gclb.backend_services["prometheus-be"].self_link
    description     = null
    name            = "prometheus"
  }

  host_rule {
    hosts        = ["wishlist.asadali.ie"]
    path_matcher = "wishlist"
  }

  path_matcher {
    default_service = module.classic-gclb.backend_services["wishlist-be"].self_link
    description     = null
    name            = "wishlist"
  }

  host_rule {
    hosts        = ["secure-java21-gsm-api.asadali.ie"]
    path_matcher = "secure-java21-gsm-api"
  }

  path_matcher {
    default_service = module.classic-gclb.backend_services["secure-java21-gsm-api-be"].self_link
    description     = null
    name            = "secure-java21-gsm-api"
  }

}


resource "google_compute_global_address" "external-gclb" {
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
  name         = "external-gclb"
  project      = var.project_id
}

resource "google_storage_bucket" "dummy_backend_bucket" {
  location      = "US"
  name          = format("%s-dummy-backend-bucket", var.project_id)
  storage_class = "MULTI_REGIONAL"
}