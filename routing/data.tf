data "ibm_is_vpc_routing_table" "example_routing_table_name" {
  vpc  = var.vpc_id
  name = var.routing_table_name
}