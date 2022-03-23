data "ibm_is_zones" "regional" {
  region = var.region
}

data "ibm_resource_group" "lab" {
  name = var.resource_group
}

data "ibm_is_ssh_key" "regional" {
  name = var.ssh_key
}

data "ibm_resource_instance" "cos_instance" {
  name              = var.cos_instance
  resource_group_id = data.ibm_resource_group.lab.id
  service           = "cloud-object-storage"
  location          = "global"
}