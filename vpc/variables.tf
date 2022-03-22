variable "address_prefix_management" {
  description = "Indicates whether a default address prefix should be created automatically. Default is auto"
  type        = string
  default     = "auto"
}

variable "resource_group_id" {
  description = "ID for the resource group to use for deployment resources."
  type        = string
  default     = ""
}

variable "name" {}
variable "tags" {}