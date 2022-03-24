output "fortigate_vnf_public_ip" {
  value = module.fortigate.FortiGate_Public_IP
}

output "fortigate_admin_username" {
  value = module.fortigate.Username
}

output "fortigate_admin_password" {
  value = module.fortigate.Default_Admin_Password
}

output "fortigate_port1_collector_bucket" {
  value = module.flowlogs.fortigate_port1_collector_bucket
}

output "fortigate_port2_collector_bucket" {
  value = module.flowlogs.fortigate_port2_collector_bucket
}

output "vm1_private_ip_address" {
  value = module.vm1.instance.primary_network_interface[0].primary_ipv4_address
}

output "vm1_subnet_collector_bucket" {
  value = module.flowlogs.vm1_subnet_collector_bucket
}

output "vm2_private_ip_address" {
  value = module.vm2.instance.primary_network_interface[0].primary_ipv4_address
}

output "vm2_subnet_collector_bucket" {
  value = module.flowlogs.vm2_subnet_collector_bucket
}