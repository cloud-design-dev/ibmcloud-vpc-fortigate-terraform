resource "ibm_is_subnet_routing_table_attachment" "vm1_subnet" {
  subnet        = var.vm1_subnet_id
  routing_table = var.vm1_subnet_routing_table
}

resource "ibm_is_subnet_routing_table_attachment" "vm2_subnet" {
  subnet        = var.vm2_subnet_id
  routing_table = var.vm2_subnet_routing_table
}

resource "ibm_is_vpc_routing_table_route" "vm1_subnet_route_table1" {
  vpc           = var.vpc_id
  routing_table = var.vm1_subnet_routing_table
  zone          = var.zone
  name          = "${var.name}-vm1-subnet-route-table-1"
  destination   = var.vm1_subnet_cidr
  action        = "deliver"
  next_hop      = var.fortiate_port_1_private_ip
}

resource "ibm_is_vpc_routing_table_route" "vm2_subnet_route_table1" {
  vpc           = var.vpc_id
  routing_table = var.vm1_subnet_routing_table
  zone          = var.zone
  name          = "${var.name}-vm2-subnet-route-table-1"
  destination   = var.vm2_subnet_cidr
  action        = "deliver"
  next_hop      = var.fortiate_port_1_private_ip
}

resource "ibm_is_vpc_routing_table_route" "vm2_subnet_route" {
  vpc           = var.vpc_id
  routing_table = var.vm2_subnet_routing_table
  zone          = var.zone
  name          = "${var.name}-vm2-subnet-route-table-2"
  destination   = var.vm2_subnet_cidr
  action        = "deliver"
  next_hop      = var.fortiate_port_1_private_ip
}

