##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# ICD Enterprise database
##############################################################################

module "database" {
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  name              = "${var.prefix}-edb"
  edb_version       = var.edb_version
  region            = var.region
  tags              = var.resource_tags
  access_tags       = var.access_tags
  service_endpoints = var.service_endpoints
  service_credential_names = {
    "enterprisedb_admin" : "Administrator",
    "enterprisedb_operator" : "Operator",
    "enterprisedb_viewer" : "Viewer",
    "enterprisedb_editor" : "Editor",
  }
}

##############################################################################
# ICD enterprise db read-only-replica
##############################################################################

module "read_only_replica_enterprise_db" {
  count             = var.read_only_replicas_count
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  name              = "${var.prefix}-read-only-replica-${count.index}"
  region            = var.region
  tags              = var.resource_tags
  access_tags       = var.access_tags
  edb_version       = var.edb_version
  remote_leader_crn = module.database.crn
  memory_mb         = 4096  # The minimum size of a read-only replica is 3 GB RAM
  disk_mb           = 61440 # The minimum size of a read-only replica is 60 GB of disk
}
