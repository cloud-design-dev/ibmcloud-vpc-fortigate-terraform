module "vpc" {
  source            = "./vpc"
  name              = var.project_prefix
  resource_group_id = data.ibm_resource_group.lab.id
  tags              = concat(var.tags, ["region:${var.region}", "project:${var.project_prefix}"])
}

module "fortigate_port_1_subnet_public" {
  source                    = "./subnet"
  name                      = "${var.project_prefix}-port1-subnet"
  vpc_id                    = module.vpc.lab_vpc_id
  resource_group_id         = data.ibm_resource_group.lab.id
  zone                      = data.ibm_is_zones.regional.zones[0]
  routing_table             = module.vpc.vpc_info.default_routing_table
  vpc_default_network_acl   = module.vpc.vpc_info.default_network_acl
  vpc_default_routing_table = module.vpc.vpc_info.default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

module "fortigate_port_2_subnet_private" {
  source                    = "./subnet"
  name                      = "${var.project_prefix}-port2-subnet"
  vpc_id                    = module.vpc.lab_vpc_id
  resource_group_id         = data.ibm_resource_group.lab.id
  zone                      = data.ibm_is_zones.regional.zones[0]
  routing_table             = module.vpc.vpc_info.default_routing_table
  vpc_default_network_acl   = module.vpc.vpc_info.default_network_acl
  vpc_default_routing_table = module.vpc.vpc_info.default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

module "vm1_subnet" {
  source                    = "./subnet"
  name                      = "${var.project_prefix}-vm1-subnet"
  vpc_id                    = module.vpc.lab_vpc_id
  resource_group_id         = data.ibm_resource_group.lab.id
  zone                      = data.ibm_is_zones.regional.zones[0]
  routing_table             = module.vpc.vpc_info.default_routing_table
  vpc_default_network_acl   = module.vpc.vpc_info.default_network_acl
  vpc_default_routing_table = module.vpc.vpc_info.default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

module "vm2_subnet" {
  source                    = "./subnet"
  name                      = "${var.project_prefix}-vm2-subnet"
  vpc_id                    = module.vpc.lab_vpc_id
  resource_group_id         = data.ibm_resource_group.lab.id
  zone                      = data.ibm_is_zones.regional.zones[0]
  routing_table             = module.vpc.vpc_info.default_routing_table
  vpc_default_network_acl   = module.vpc.vpc_info.default_network_acl
  vpc_default_routing_table = module.vpc.vpc_info.default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

module "fortigate" {
  depends_on        = [module.vpc]
  source            = "git::https://github.com/cloud-design-dev/ibm-fortigate-terraform-deploy.git"
  cluster_name      = var.project_prefix
  ssh_public_key    = var.ssh_key
  region            = var.region
  vpc_id            = module.vpc.lab_vpc_id
  resource_group_id = data.ibm_resource_group.lab.id
  zone              = data.ibm_is_zones.regional.zones[0]
  subnet1           = module.fortigate_port_1_subnet_public.subnet_id
  subnet2           = module.fortigate_port_2_subnet_private.subnet_id
  security_group    = module.vpc.vpc_info.default_security_group
}

module "vm1" {
  source            = "./compute"
  name              = "${var.project_prefix}-vm-1"
  vpc_id            = module.vpc.lab_vpc_id
  ssh_key           = [data.ibm_is_ssh_key.regional.id]
  subnet_id         = module.vm1_subnet.subnet_id
  zone              = data.ibm_is_zones.regional.zones[0]
  security_groups   = module.vpc.vpc_info.default_security_group
  resource_group_id = data.ibm_resource_group.lab.id
  tags              = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

module "vm2" {
  source            = "./compute"
  name              = "${var.project_prefix}-vm-2"
  vpc_id            = module.vpc.lab_vpc_id
  ssh_key           = [data.ibm_is_ssh_key.regional.id]
  subnet_id         = module.vm1_subnet.subnet_id
  zone              = data.ibm_is_zones.regional.zones[0]
  security_groups   = module.vpc.vpc_info.default_security_group
  resource_group_id = data.ibm_resource_group.lab.id
  tags              = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

module "flowlogs" {
  depends_on                = [module.fortigate]
  source                    = "./flowlogs"
  name                      = var.project_prefix
  fortigate_port1_interface = module.fortigate.fortigate_instance_info.primary_network_interface[0].id
  fortigate_port2_interface = module.fortigate.fortigate_instance_info.network_interfaces[0].id
  vm1_subnet                = module.vm1_subnet.subnet_id
  vm2_subnet                = module.vm2_subnet.subnet_id
  cos_instance              = data.ibm_resource_instance.cos_instance.id
  resource_group_id         = data.ibm_resource_group.lab.id
  vpc_id                    = module.vpc.lab_vpc_id
  region                    = var.region
  tags                      = concat(var.tags, ["region:${var.region}", "project:${var.project_prefix}"])
}

module "routing_table_updates" {
  depends_on                 = [module.flowlogs]
  source                     = "./routing"
  name                       = var.project_prefix
  fortiate_port_1_private_ip = module.fortigate.fortigate_instance_info.primary_network_interface[0].primary_ipv4_address
  vm1_subnet_id              = module.vm1_subnet.subnet_id
  vm2_subnet_id              = module.vm2_subnet.subnet_id
  vm1_subnet_cidr            = module.vm1_subnet.cidr_block
  vm2_subnet_cidr            = module.vm1_subnet.cidr_block
  vm1_subnet_routing_table   = module.fortigate.fgt_vm1_routing_table.routing_table
  vm2_subnet_routing_table   = module.fortigate.fgt_vm2_routing_table.routing_table
  vpc_id                     = module.vpc.lab_vpc_id
  zone                       = data.ibm_is_zones.regional.zones[0]
}