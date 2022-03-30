locals {
  resource_group_id          = var.existing_resource_group_name != "" ? data.ibm_resource_group.lab.0.id : ibm_resource_group.lab_new.0.id
  ssh_key_ids                = var.existing_ssh_key_name != "" ? [data.ibm_is_ssh_key.existing_key.0.id, ibm_is_ssh_key.new_key.id] : [ibm_is_ssh_key.new_key.id]
  vpc_id                     = var.existing_vpc_name != "" ? data.ibm_is_vpc.existing_vpc.0.id : module.vpc.0.lab_vpc_id
  vpc_default_network_acl    = var.existing_vpc_name != "" ? data.ibm_is_vpc.existing_vpc.0.default_network_acl : module.vpc.0.vpc_info.default_network_acl
  vpc_default_routing_table  = var.existing_vpc_name != "" ? data.ibm_is_vpc.existing_vpc.0.default_routing_table : module.vpc.0.vpc_info.default_routing_table
  vpc_default_security_group = var.existing_vpc_name != "" ? data.ibm_is_vpc.existing_vpc.0.default_security_group : module.vpc.0.vpc_info.default_security_group
  fortigate_port1_subnet_id  = var.existing_port1_subnet_name != "" ? data.ibm_is_subnet.port1_existing_subnet.0.id : module.fortigate_port_1_subnet_public.0.subnet_id
  fortigate_port2_subnet_id  = var.existing_port2_subnet_name != "" ? data.ibm_is_subnet.port2_existing_subnet.0.id : module.fortigate_port_2_subnet_private.0.subnet_id
}

## If no existing Resource Group name specified, a new one is created for the project
resource "ibm_resource_group" "lab_new" {
  count = var.existing_resource_group_name != "" ? 0 : 1
  name  = "${var.project_prefix}-group"
  tags  = concat(var.tags, ["project:${var.project_prefix}"])
}

## Generate SSH key that will be added to existing keys
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## If no existing SSH key is defined, one is generated and added to the region. If an existing key is used, this key will still be generated and both will be added to the compute resources.
resource "ibm_is_ssh_key" "new_key" {
  name           = "${var.project_prefix}-${var.region}-key"
  public_key     = tls_private_key.ssh.public_key_openssh
  resource_group = local.resource_group_id
  tags           = concat(var.tags, ["region:${var.region}", "project:${var.project_prefix}"])
}

## If no existing VPC is speficied, one will be created for this project.
module "vpc" {
  depends_on        = [ibm_is_ssh_key.new_key]
  count             = var.existing_vpc_name != "" ? 0 : 1
  source            = "./vpc"
  name              = var.project_prefix
  resource_group_id = local.resource_group_id
  tags              = concat(var.tags, ["region:${var.region}", "project:${var.project_prefix}"])
}

# If no existing subnet for port 1 of the VNF is defined, create one
module "fortigate_port_1_subnet_public" {
  count                     = var.existing_port1_subnet_name != "" ? 0 : 1
  depends_on                = [module.vpc]
  source                    = "./subnet"
  name                      = "${var.project_prefix}-port1-subnet"
  vpc_id                    = local.vpc_id
  resource_group_id         = local.resource_group_id
  zone                      = data.ibm_is_zones.regional.zones[0]
  vpc_default_network_acl   = local.vpc_default_network_acl
  vpc_default_routing_table = local.vpc_default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

# If no existing subnet for port 2 of the VNF is defined, create one
module "fortigate_port_2_subnet_private" {
  count                     = var.existing_port2_subnet_name != "" ? 0 : 1
  source                    = "./subnet"
  name                      = "${var.project_prefix}-port2-subnet"
  vpc_id                    = local.vpc_id
  resource_group_id         = local.resource_group_id
  zone                      = data.ibm_is_zones.regional.zones[0]
  vpc_default_network_acl   = local.vpc_default_network_acl
  vpc_default_routing_table = local.vpc_default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

# Create VM 1 subnet to show routing of networks through VNF. Future state this will be dependent on the variable `create_vms`. 
module "vm1_subnet" {
  source                    = "./subnet"
  name                      = "${var.project_prefix}-vm1-subnet"
  vpc_id                    = local.vpc_id
  resource_group_id         = local.resource_group_id
  zone                      = data.ibm_is_zones.regional.zones[0]
  vpc_default_network_acl   = local.vpc_default_network_acl
  vpc_default_routing_table = local.vpc_default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

# Create VM 2 subnet to show routing of networks through VNF. Future state this will be dependent on the variable `create_vms`. 
module "vm2_subnet" {
  source                    = "./subnet"
  name                      = "${var.project_prefix}-vm2-subnet"
  vpc_id                    = local.vpc_id
  resource_group_id         = local.resource_group_id
  zone                      = data.ibm_is_zones.regional.zones[0]
  vpc_default_network_acl   = local.vpc_default_network_acl
  vpc_default_routing_table = local.vpc_default_routing_table
  tags                      = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

# Create Fortigate VNF deployment using my fork of the official tf deployment
module "fortigate" {
  depends_on        = [module.vpc]
  source            = "git::https://github.com/cloud-design-dev/ibm-fortigate-terraform-deploy.git"
  cluster_name      = var.project_prefix
  ssh_public_keys   = local.ssh_key_ids
  region            = var.region
  vpc_id            = local.vpc_id
  resource_group_id = local.resource_group_id
  zone              = data.ibm_is_zones.regional.zones[0]
  subnet1           = local.fortigate_port1_subnet_id
  subnet2           = local.fortigate_port2_subnet_id
  security_group    = local.vpc_default_security_group
}

# Create VM 1 to show routing of networks through VNF. Future state this will be dependent on the variable `create_vms`. 
module "vm1" {
  source            = "./compute"
  name              = "${var.project_prefix}-vm-1"
  vpc_id            = local.vpc_id
  resource_group_id = local.resource_group_id
  ssh_key           = local.ssh_key_ids
  subnet_id         = module.vm1_subnet.subnet_id
  zone              = data.ibm_is_zones.regional.zones[0]
  security_groups   = local.vpc_default_security_group
  tags              = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

# Create VM 2 to show routing of networks through VNF. Future state this will be dependent on the variable `create_vms`. 
module "vm2" {
  source            = "./compute"
  name              = "${var.project_prefix}-vm-2"
  vpc_id            = local.vpc_id
  resource_group_id = local.resource_group_id
  ssh_key           = local.ssh_key_ids
  subnet_id         = module.vm1_subnet.subnet_id
  zone              = data.ibm_is_zones.regional.zones[0]
  security_groups   = local.vpc_default_security_group
  tags              = concat(var.tags, ["zone:${data.ibm_is_zones.regional.zones[0]}", "region:${var.region}", "project:${var.project_prefix}"])
}

# Create flowlog buckets and associated collectors for VNF interfaces and VM subnets. Future state this will be dependent on the variable `create_flowlogs=true|false`. 
module "flowlogs" {
  depends_on                = [module.fortigate]
  source                    = "./flowlogs"
  name                      = var.project_prefix
  fortigate_port1_interface = module.fortigate.fortigate_instance_info.primary_network_interface[0].id
  fortigate_port2_interface = module.fortigate.fortigate_instance_info.network_interfaces[0].id
  vm1_subnet                = module.vm1_subnet.subnet_id
  vm2_subnet                = module.vm2_subnet.subnet_id
  cos_instance              = data.ibm_resource_instance.cos_instance.id
  vpc_id                    = local.vpc_id
  resource_group_id         = local.resource_group_id
  region                    = var.region
  tags                      = concat(var.tags, ["region:${var.region}", "project:${var.project_prefix}"])
}

# Update routing table for VMs to route all traffic through VNF 
module "routing_table_updates" {
  depends_on                 = [module.flowlogs]
  source                     = "./routing"
  name                       = var.project_prefix
  fortiate_port_1_private_ip = module.fortigate.fortigate_instance_info.primary_network_interface[0].primary_ipv4_address
  vm1_subnet_id              = module.vm1_subnet.subnet_id
  vm2_subnet_id              = module.vm2_subnet.subnet_id
  vm1_subnet_cidr            = module.vm1_subnet.cidr_block
  vm2_subnet_cidr            = module.vm2_subnet.cidr_block
  vm1_subnet_routing_table   = module.fortigate.fgt_vm1_routing_table.routing_table
  vm2_subnet_routing_table   = module.fortigate.fgt_vm2_routing_table.routing_table
  vpc_id                     = local.vpc_id
  zone                       = data.ibm_is_zones.regional.zones[0]
}
