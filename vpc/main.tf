resource "ibm_is_vpc" "lab" {
  name                        = "${var.name}-vpc"
  resource_group              = var.resource_group_id
  address_prefix_management   = var.address_prefix_management
  default_network_acl_name    = "${var.name}-default-acl"
  default_security_group_name = "${var.name}-default-security-group"
  default_routing_table_name  = "${var.name}-default-routing-table"
  tags                        = concat(var.tags)
}