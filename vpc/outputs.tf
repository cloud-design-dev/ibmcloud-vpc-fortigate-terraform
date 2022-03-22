output "vpc_info" {
  value = ibm_is_vpc.lab
}

output "lab_vpc_id" {
  value = ibm_is_vpc.lab.id
}
