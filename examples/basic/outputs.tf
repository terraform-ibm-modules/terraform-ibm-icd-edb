##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "Enterprise DB instance id"
  value       = module.enterprise_db.id
}

output "version" {
  description = "Enterprise DB instance version"
  value       = module.enterprise_db.version
}
