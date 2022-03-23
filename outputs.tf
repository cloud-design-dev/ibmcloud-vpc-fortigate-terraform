output "Fortigate_Public_IP" {
  value = module.fortigate.FortiGate_Public_IP
}

output "vm1_private_ip_address" {
  value = module.vm1.instance.primary_network_interface[0].primary_ipv4_address
}

output "vm2_private_ip_address" {
  value = module.vm2.instance.primary_network_interface[0].primary_ipv4_address
}

output "fortigate_port1_collector_bucket" {
  value = module.flowlogs.fortigate_port1_collector_bucket
}

output "fortigate_port2_collector_bucket" {
  value = module.flowlogs.fortigate_port2_collector_bucket
}

output "vm1_subnet_collector_bucket" {
  value = module.flowlogs.vm1_subnet_collector_bucket
}

output "vm2_subnet_collector_bucket" {
  value = module.flowlogs.vm2_subnet_collector_bucket
}

output "List_Routing_Tables_For_VPC" {
  value = "ibmcloud is vpc-routing-tables ${module.vpc.lab_vpc_id}"
}