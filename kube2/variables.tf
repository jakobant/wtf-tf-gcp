

variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "credentials_file" {
  description = "The service credentials file for the project"
}

variable "demo_bucket" {
  description = "Bucket for the Vikingr results"
}

variable "database" {
  description = "Database name"
}

// kube
variable "cluster_name" {
  description = "The name for the GKE cluster"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west2"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
}

variable "subnet_region" {
  description = "The region of the subnet"
  default     = "europe-west2"
}

variable "zones" {
  description = "List of zones"
  default     = ["europe-west2-a"]
}

variable "subnet_ip" {
  description = "The subnet ip range for the region"
  default     = "10.10.0.0/20"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_cidr_range_pods" {
  description = "The secondary ip range for pods"
  default     = "192.168.0.0/18"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-scv"
}

variable "ip_cidr_range_service" {
  description = "The secondary ip range to use for services"
  default     = "192.168.64.0/18"
}

variable "machine_type" {
  description = ""
  default     = "n1-standard-2"
}

variable "min_count" {
  description = ""
}

variable "max_count" {
  description = ""
}

variable "node_count" {
  description = ""
}
