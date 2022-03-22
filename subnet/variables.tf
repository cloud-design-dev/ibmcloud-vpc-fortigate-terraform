variable "name" {}
variable "vpc_id" {}
variable "resource_group_id" {}
variable "zone" {}
variable "routing_table" {}
variable "vpc_default_network_acl" {}

variable "vpc_default_routing_table" {}

variable "tags" {}

variable "total_ipv4_address_count" {
  default = "128"
}