resource "ibm_is_instance" "instance" {
  name           = var.name
  vpc            = var.vpc_id
  zone           = var.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.ubuntu20.id
  keys           = var.ssh_key
  resource_group = var.resource_group_id


  user_data = file("${path.module}/init.yml")


  primary_network_interface {
    subnet            = var.subnet_id
    security_groups   = [var.security_groups]
    allow_ip_spoofing = false
  }

  boot_volume {
    name = "${var.name}-boot-volume"
  }

  tags = var.tags
}