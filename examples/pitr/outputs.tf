##############################################################################
# Outputs
##############################################################################

output "pitr_enterprise_db_id" {
  description = "PITR Enterprise DB instance id"
  value       = module.enterprise_db_pitr.id
}

output "pitr_enterprise_db_version" {
  description = "PITR Enterprise DB instance version"
  value       = module.enterprise_db_pitr.version
}

output "pitr_time" {
  description = "PITR timestamp in UTC format (%Y-%m-%dT%H:%M:%SZ) used to create PITR instance"
  value       = var.pitr_time
}
