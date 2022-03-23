output "fortigate_port1_collector_bucket" {
  value = ibm_cos_bucket.fortigate_port1_collector_bucket.bucket_name
}

output "fortigate_port2_collector_bucket" {
  value = ibm_cos_bucket.fortigate_port2_collector_bucket.bucket_name
}

output "vm1_subnet_collector_bucket" {
  value = ibm_cos_bucket.vm1_subnet_collector_bucket.bucket_name
}

output "vm2_subnet_collector_bucket" {
  value = ibm_cos_bucket.vm2_subnet_collector_bucket.bucket_name
}