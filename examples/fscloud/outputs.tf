##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "Enterprise DB instance id"
  value       = module.enterprise_db.id
}

output "guid" {
  description = "Enterprise DB instance guid"
  value       = module.enterprise_db.guid
}

output "version" {
  description = "Enterprise DB instance version"
  value       = module.enterprise_db.version
}
