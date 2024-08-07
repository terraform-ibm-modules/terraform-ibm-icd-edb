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

module "enterprise_db" {
  count              = var.enterprise_db_backup_crn != null ? 0 : 1
  source             = "../.."
  resource_group_id  = module.resource_group.resource_group_id
  name               = "${var.prefix}-edb"
  edb_version        = var.edb_version
  region             = var.region
  resource_tags      = var.resource_tags
  access_tags        = var.access_tags
  member_host_flavor = "b3c.4x16.encrypted"
}

data "ibm_database_backups" "backup_database" {
  count         = var.enterprise_db_backup_crn != null ? 0 : 1
  deployment_id = module.enterprise_db[0].id
}

# New enterprise db instance pointing to the backup instance
module "restored_enterprise_db" {
  source             = "../.."
  resource_group_id  = module.resource_group.resource_group_id
  name               = "${var.prefix}-edb-restored"
  edb_version        = var.edb_version
  region             = var.region
  resource_tags      = var.resource_tags
  access_tags        = var.access_tags
  member_host_flavor = "b3c.4x16.encrypted"
  backup_crn         = var.enterprise_db_backup_crn == null ? data.ibm_database_backups.backup_database[0].backups[0].backup_id : var.enterprise_db_backup_crn
}
