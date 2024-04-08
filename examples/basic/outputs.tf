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

output "adminuser" {
  description = "Database admin user name"
  value       = module.enterprise_db.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.enterprise_db.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.enterprise_db.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.enterprise_db.certificate_base64
  sensitive   = true
}
