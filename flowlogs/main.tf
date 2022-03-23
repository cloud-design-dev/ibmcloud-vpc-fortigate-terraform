
resource "ibm_cos_bucket" "fortigate_port1_collector_bucket" {
  bucket_name          = "${var.name}-${var.region}-fortiage-port-1-flowlogs-collector-bucket"
  resource_instance_id = var.cos_instance
  region_location      = var.region
  storage_class        = "smart"
}

resource "ibm_cos_bucket" "fortigate_port2_collector_bucket" {
  bucket_name          = "${var.name}-${var.region}-fortiage-port-2-flowlogs-collector-bucket"
  resource_instance_id = var.cos_instance
  region_location      = var.region
  storage_class        = "smart"
}

resource "ibm_cos_bucket" "vm1_subnet_collector_bucket" {
  bucket_name          = "${var.name}-${var.region}-vm1-subnet-flowlogs-collector-bucket"
  resource_instance_id = var.cos_instance
  region_location      = var.region
  storage_class        = "smart"
}

resource "ibm_cos_bucket" "vm2_subnet_collector_bucket" {
  bucket_name          = "${var.name}-${var.region}-vm2-subnet-flowlogs-collector-bucket"
  resource_instance_id = var.cos_instance
  region_location      = var.region
  storage_class        = "smart"
}

resource "ibm_is_flow_log" "fortigate_port1_collector" {
  depends_on     = [ibm_cos_bucket.fortigate_port1_collector_bucket]
  name           = "${var.name}-${var.region}-fortiage-port-1-flowlogs-collector"
  target         = var.fortigate_port1_interface
  active         = true
  storage_bucket = ibm_cos_bucket.fortigate_port1_collector_bucket.bucket_name
  resource_group = var.resource_group_id
  tags           = var.tags
}


resource "ibm_is_flow_log" "fortigate_port2_collector" {
  depends_on     = [ibm_cos_bucket.fortigate_port2_collector_bucket]
  name           = "${var.name}-${var.region}-fortiage-port-2-flowlogs-collector"
  target         = var.fortigate_port2_interface
  active         = true
  storage_bucket = ibm_cos_bucket.fortigate_port2_collector_bucket.bucket_name
  resource_group = var.resource_group_id
  tags           = var.tags
}

resource "ibm_is_flow_log" "vm1_subnet_collector" {
  depends_on     = [ibm_cos_bucket.vm1_subnet_collector_bucket]
  name           = "${var.name}-${var.region}-vm1-subnet-flowlogs-collector"
  target         = var.vm1_subnet
  active         = true
  storage_bucket = ibm_cos_bucket.vm1_subnet_collector_bucket.bucket_name
  resource_group = var.resource_group_id
  tags           = var.tags
}

resource "ibm_is_flow_log" "vm2_subnet_collector" {
  depends_on     = [ibm_cos_bucket.vm2_subnet_collector_bucket]
  name           = "${var.name}-${var.region}-vm2-subnet-flowlogs-collector"
  target         = var.vm2_subnet
  active         = true
  storage_bucket = ibm_cos_bucket.vm2_subnet_collector_bucket.bucket_name
  resource_group = var.resource_group_id
  tags           = var.tags
}