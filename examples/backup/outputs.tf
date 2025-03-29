##############################################################################
# Outputs
##############################################################################
output "restored_icd_enterprise_db_id" {
  description = "Restored Enterprise DB instance id"
  value       = module.restored_icd_enterprise_db.id
}

output "restored_icd_enterprise_db_version" {
  description = "Restored Enterprise DB instance version"
  value       = module.restored_icd_enterprise_db.version
}
