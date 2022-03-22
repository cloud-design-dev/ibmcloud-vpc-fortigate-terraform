resource "ibm_is_subnet" "lab" {
  name                     = var.name
  vpc                      = var.vpc_id
  zone                     = var.zone
  network_acl              = var.vpc_default_network_acl
  resource_group           = var.resource_group_id
  routing_table            = var.vpc_default_routing_table
  tags                     = var.tags
  total_ipv4_address_count = var.total_ipv4_address_count
}