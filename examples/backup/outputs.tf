##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "Enterprise DB instance id"
  value       = var.enterprise_db_backup_crn == null ? module.enterprise_db[0].id : null
}

output "restored_enterprise_db_id" {
  description = "Restored Enterprise DB instance id"
  value       = module.restored_enterprise_db.id
}

output "restored_enterprise_db_version" {
  description = "Restored Enterprise DB instance version"
  value       = module.restored_enterprise_db.version
}
