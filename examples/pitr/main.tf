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

data "ibm_database_point_in_time_recovery" "database_pitr" {
  deployment_id = var.pitr_id
}

# New ICD enterprise database instance pointing to a PITR time
module "enterprise_db_pitr" {
  source             = "../.."
  resource_group_id  = module.resource_group.resource_group_id
  name               = "${var.prefix}-edb-pitr"
  region             = var.region
  resource_tags      = var.resource_tags
  access_tags        = var.access_tags
  member_host_flavor = "multitenant"
  member_memory_mb   = 4096  # 1*3*1024
  member_disk_mb     = 61440 # 3*20**1024
  member_cpu_count   = 9
  members            = var.members
  edb_version        = var.edb_version
  pitr_id            = var.pitr_id
  pitr_time          = data.ibm_database_point_in_time_recovery.database_pitr.earliest_point_in_time_recovery_time
}
