data "ibm_is_zones" "regional" {
  region = var.region
}

data "ibm_resource_group" "lab" {
  count = var.existing_resource_group_name != "" ? 1 : 0
  name  = var.existing_resource_group_name
}

data "ibm_is_ssh_key" "existing_key" {
  count = var.existing_ssh_key_name != "" ? 1 : 0
  name  = var.existing_ssh_key_name
}

data "ibm_resource_instance" "cos_instance" {
  name              = var.cos_instance
  resource_group_id = local.resource_group_id
  service           = "cloud-object-storage"
  location          = "global"
}

data "ibm_is_vpc" "existing_vpc" {
  count = var.existing_vpc_name != "" ? 1 : 0
  name  = var.existing_vpc_name
}

data "ibm_is_subnet" "existing_subnet" {
  count = var.existing_subnet_name != "" ? 1 : 0
  name  = var.existing_subnet_name
}