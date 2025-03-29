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

# New ICD enterprise database instance pointing to a PITR time
module "enterprise_db_pitr" {
  source             = "../.."
  resource_group_id  = module.resource_group.resource_group_id
  name               = "${var.prefix}-edb-pitr"
  region             = var.region
  tags               = var.resource_tags
  access_tags        = var.access_tags
  member_host_flavor = "b3c.4x16.encrypted"
  memory_mb          = 4096  # 1*3*1024
  disk_mb            = 61440 # 3*20**1024
  cpu_count          = 9
  members            = var.members
  edb_version        = var.edb_version
  pitr_id            = var.pitr_id
  pitr_time          = var.pitr_time == "" ? " " : var.pitr_time
}
