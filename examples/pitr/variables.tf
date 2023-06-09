variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "edb-pitr"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "edb_version" {
  description = "Version of the Enterprise DB instance. If no value passed, the current ICD preferred version is used."
  type        = string
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to add to resources that are created"
  default     = []
}

variable "pitr_id" {
  type        = string
  description = "The ID of the source deployment Enterprise DB instance that you want to recover back to. The Enterprise DB instance is expected to be in an up and running state."
}

variable "members" {
  type        = number
  description = "Allocated number of members. Members must be same or higher than the source deployment Enterprise DB instance."
  default     = 3
}
