output "vm1_subnet_routing_table_routes" {
  value = ibm_is_subnet_routing_table_attachment.vm1_subnet.routes
}

output "vm2_subnet_routing_table_routes" {
  value = ibm_is_subnet_routing_table_attachment.vm2_subnet.routes
}