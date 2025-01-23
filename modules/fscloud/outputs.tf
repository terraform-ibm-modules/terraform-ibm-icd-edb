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

output "crn" {
  description = "Enterprise DB instance crn"
  value       = module.enterprise_db.crn
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

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict EnterpriseDB"
  value       = module.enterprise_db.cbr_rule_ids
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.enterprise_db.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.enterprise_db.service_credentials_object
  sensitive   = true
}
