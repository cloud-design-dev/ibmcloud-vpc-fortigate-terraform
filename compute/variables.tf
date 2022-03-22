
## If you need to change the os for additional testing you can use the followinvg command to get a list of available OSes
## ibmcloud is images --visibility public --json | jq -r '.[] | select(.status=="available") | .name, .id'
variable "image_name" {
  description = "Default OS image to use for test instances."
  type        = string
  default     = "ibm-ubuntu-20-04-3-minimal-amd64-2"
}

variable "ssh_key" {}


variable "name" {}

variable "zone" {}

variable "vpc_id" {}

variable "resource_group_id" {}

variable "security_groups" {}

variable "tags" {}

variable "subnet_id" {}

variable "profile_name" {
  default = "cx2-4x8"
}