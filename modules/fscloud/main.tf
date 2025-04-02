module "enterprise_db" {
  source                            = "../.."
  resource_group_id                 = var.resource_group_id
  edb_version                       = var.edb_version
  region                            = var.region
  skip_iam_authorization_policy     = var.skip_iam_authorization_policy
  name                              = var.name
  service_endpoints                 = "private"
  cbr_rules                         = var.cbr_rules
  configuration                     = var.configuration
  cpu_count                         = var.cpu_count
  memory_mb                         = var.memory_mb
  disk_mb                           = var.disk_mb
  member_host_flavor                = var.member_host_flavor
  members                           = var.members
  admin_pass                        = var.admin_pass
  users                             = var.users
  use_ibm_owned_encryption_key      = var.use_ibm_owned_encryption_key
  use_same_kms_key_for_backups      = var.use_same_kms_key_for_backups
  use_default_backup_encryption_key = var.use_default_backup_encryption_key
  kms_key_crn                       = var.kms_key_crn
  backup_crn                        = var.backup_crn
  backup_encryption_key_crn         = var.backup_encryption_key_crn
  auto_scaling                      = var.auto_scaling
  access_tags                       = var.access_tags
  tags                              = var.tags
  service_credential_names          = var.service_credential_names
}
