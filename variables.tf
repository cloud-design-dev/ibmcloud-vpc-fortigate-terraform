variable "region" {
  description = "VPC region where resources will be deployed. Use 'ibm is regions` for a list of available options."
  type        = string
  default     = ""
}

variable "resource_group" {
  description = "Resource group for deployed assets."
  type        = string
  default     = ""
}

variable "project_prefix" {
  description = "Name that will be prefixed to all resources"
  type        = string
  default     = ""
}
variable "ssh_key" {
  description = "SSH key in the VPC region that will be added to the Fortigate and Test VMs"
  type        = string
  default     = ""
}


variable "tags" {
  description = "Default set of tags to add to all supported resources."
  type        = list(string)
  default     = []
}

