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

module "routing_table_update" {
  depends_on                 = [module.fortigate]
  source                     = "./routing"
  routing_table_name         = module.fortigate.fgt_routing_table
  vpc_id                     = module.vpc.lab_vpc_id
  fortiate_port_1_private_ip = module.fortigate.primary_private_ip
  subnet_1_cidr              = module.fortigate_port_1_subnet_public.cidr_block
}

# module "flowlogs" {
#     source = "./flowlogs"
#     fortigate_interfaces = "" 
#     cos_instance = ""  
#     resource_group_id = data.ibm_resource_group.lab.id
#     vpc = module.vpc.lab_vpc_id

# }