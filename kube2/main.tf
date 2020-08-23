terraform {
}

//Dns topics scans
resource "google_pubsub_topic" "topic-scan-dns" {
  project = var.project_id
  name = "topic-scan-dns"
}

resource "google_storage_bucket" "demo-dns" {
  name          = var.demo_bucket
  location      = "EU"
  project = var.project_id
  force_destroy = true
  bucket_policy_only = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}


data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}


module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.0"
  project_id   = var.project_id
  network_name = var.network

  subnets = [
    {
      subnet_name   = var.subnetwork
      subnet_ip     = var.subnet_ip
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnetwork}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = var.ip_cidr_range_pods
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = var.ip_cidr_range_service
      },
    ]
  }
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  project_id             = var.project_id
  name                   = var.cluster_name
  regional               = false
  region                 = var.region
  zones                  = var.zones
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  create_service_account = true
  remove_default_node_pool = true
  initial_node_count       = 1

  node_pools = [
    {
      name         = "onlyone-pool"
      machine_type = var.machine_type
      min_count    = 1
      max_count    = 1
      node_count   = 1
      autoscaling  = true
      auto_repair  = false
      //zones        = var.zones
    },
    {
      name         = "preemptible-pool"
      machine_type = var.machine_type
      min_count    = var.min_count
      max_count    = var.max_count
      node_count   = var.node_count
      autoscaling  = true
      auto_repair  = false
      preemptible  = true
    },
  ]
}

data "google_client_config" "default" {
}

locals {
  onprem = ["153.92.146.175/32", "178.19.58.137/32"]
}

data "google_compute_network" "demo_network" {
  name = var.network
  project = var.project_id
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  project = var.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.demo_network.self_link
}


resource "google_sql_database_instance" "demodb" {
  name             = var.database
  database_version = "POSTGRES_12"
  region           = var.region
  project          = var.project_id

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled    = true
      private_network = data.google_compute_network.demo_network.self_link
      dynamic "authorized_networks" {
        for_each = local.onprem
        iterator = onprem
        content {
          name  = "Remote"
          value = onprem.value
        }
      }
    }
  }
}

resource "google_sql_database" "database" {
  name     = "demo1"
  project  = var.project_id
  instance = google_sql_database_instance.demodb.name
}

resource "google_sql_user" "users" {
  name     = "demo1"
  project  = var.project_id
  instance = google_sql_database_instance.demodb.name
  password = "changemeS00n"
}


