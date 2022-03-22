data "ibm_is_zones" "regional" {
  region = var.region
}

data "ibm_resource_group" "lab" {
  name = var.resource_group
}

data "ibm_is_ssh_key" "regional" {
  name = var.ssh_key
}
