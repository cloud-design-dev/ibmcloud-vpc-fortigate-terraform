variable "ibmcloud_api_key" {
  description = "IBM Cloud API Key to use for the Terraform deployment."
  type        = string
  default     = ""
}

variable "region" {
  description = "VPC region where resources will be deployed. Use 'ibm is regions` for a list of available options."
  type        = string
  default     = ""
}

variable "existing_resource_group_name" {
  description = "Name of an existing IBM Cloud Resource group for the project. If none is provided a new one will be created and used for the lab resources."
  type        = string
}

variable "project_prefix" {
  description = "Name that will be prefixed to all resources"
  type        = string
  default     = ""
}

variable "existing_ssh_key_name" {
  description = "Name of an SSH key that has already been added to the VPC region. If none provided a new one will be created and added to the Fortigate and Test VMs. The newly generated key is also added when you supply an existing key."
  type        = string
}

variable "cos_instance" {
  description = "The COS instance where Flowlogs collector buckets will be created"
  type        = string
}

variable "existing_vpc_name" {
  description = "Name of an existing VPC to use for the Fortigate deployment."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Default set of tags to add to all supported resources."
  type        = list(string)
  default     = ["deployed_from:terraform"]
}

variable "existing_port1_subnet_name" {
  description = "Name of an existing Subnet to use for Port 1 of the Fortigate deployment. "
  type        = string
  default     = ""
}

variable "existing_port2_subnet_name" {
  description = "Name of an existing Subnet to use for Port 2 of the Fortigate deployment. "
  type        = string
  default     = ""
}
