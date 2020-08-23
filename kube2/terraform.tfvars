// Project
project_id       = "stalwart-camera-276219"
credentials_file = "stalwart-camera-276219-ae83b60715a2.json"
demo_bucket   = "demo-stuff-wtf"
database = "demodb"

//Cluster
cluster_name  = "demo-gke"
region        = "europe-west2"
subnet_region = "europe-west2"
zones         = ["europe-west2-a"]
network       = "demo-network"
subnetwork    = "demo-subnet"
subnet_ip     = "10.0.0.0/20"

ip_range_pods_name = "ip-range-pods"
ip_cidr_range_pods = "192.168.0.0/22"
ip_range_services_name = "ip-range-service"
ip_cidr_range_service  = "192.168.4.0/22"

//Nodes
machine_type = "n1-standard-2"
min_count    = 1
max_count    = 1
node_count   = 1

