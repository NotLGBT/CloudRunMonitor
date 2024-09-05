terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 2.7.0"
    }
  }
}

# resource "google_service_account" "default" {
#   account_id = "1070081671072"
#   display_name = "Service Account"
  
# }
resource "google_compute_network" "custom" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-central2"
  network       = google_compute_network.custom.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}



resource "google_container_cluster" "primary" {
  name               = "my-vpc-native-cluster"
  location           = "europe-central2"
  remove_default_node_pool = true
  initial_node_count = 1
  node_locations     = ["europe-central2-a", "europe-central2-b"]
  network    = google_compute_network.custom.id
  subnetwork = google_compute_subnetwork.custom.id
  
  monitoring_service = "none"
  logging_service = "none"
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = google_compute_subnetwork.custom.secondary_ip_range.0.range_name
  }
  
}

resource "google_container_node_pool" "cluster_node_pool" {
  name = "pool"
  cluster = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible = true 
    machine_type = "e2-standard-2"
    disk_size_gb = 40
    disk_type      = "pd-ssd"  
    service_account = "1070081671072-compute@developer.gserviceaccount.com"
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
  }

  
}