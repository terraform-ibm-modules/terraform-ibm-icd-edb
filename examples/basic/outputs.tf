##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "Enterprise DB instance id"
  value       = module.database.id
}

output "enterprise_db_crn" {
  description = "Enterprise database CRN"
  value       = module.database.crn
}

output "version" {
  description = "Enterprise DB instance version"
  value       = module.database.version
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.database.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.database.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.database.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.database.certificate_base64
  sensitive   = true
}
