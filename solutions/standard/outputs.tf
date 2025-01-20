##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "EnterpriseDB instance id"
  value       = module.enterprisedb.id
}

output "version" {
  description = "EnterpriseDB instance version"
  value       = module.enterprisedb.version
}

output "guid" {
  description = "EnterpriseDB instance guid"
  value       = module.enterprisedb.guid
}

output "crn" {
  description = "EnterpriseDB instance crn"
  value       = module.enterprisedb.crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict EnterpriseDB"
  value       = module.enterprisedb.cbr_rule_ids
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.enterprisedb.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.enterprisedb.service_credentials_object
  sensitive   = true
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.enterprisedb.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.enterprisedb.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.enterprisedb.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.enterprisedb.certificate_base64
  sensitive   = true
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = length(local.service_credential_secrets) > 0 ? module.secrets_manager_service_credentials[0].secrets : null
}
