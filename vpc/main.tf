resource "ibm_is_vpc" "lab" {
  name                        = "${var.name}-vpc"
  resource_group              = var.resource_group_id
  address_prefix_management   = var.address_prefix_management
  default_network_acl_name    = "${var.name}-default-acl"
  default_security_group_name = "${var.name}-default-security-group"
  default_routing_table_name  = "${var.name}-default-routing-table"
  tags                        = concat(var.tags)
}

resource "ibm_is_security_group_rule" "ssh_to_ftg" {
  depends_on = [ibm_is_vpc.lab]
  group      = ibm_is_vpc.lab.default_security_group
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "ftg_ui_http" {
  depends_on = [ibm_is_vpc.lab]
  group      = ibm_is_vpc.lab.default_security_group
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "ftg_ui_https" {
  depends_on = [ibm_is_vpc.lab]
  group      = ibm_is_vpc.lab.default_security_group
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "ftg_icmp" {
  depends_on = [ibm_is_vpc.lab]
  group      = ibm_is_vpc.lab.default_security_group
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  icmp {
    code = 0
    type = 8
  }
}