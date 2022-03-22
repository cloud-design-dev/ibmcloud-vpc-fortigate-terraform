output "subnet_id" {
  value = ibm_is_subnet.lab.id
}

output "cidr_block" {
  value = ibm_is_subnet.lab.ipv4_cidr_block
}