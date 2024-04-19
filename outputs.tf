##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "Enterprise DB instance id"
  value       = ibm_database.enterprise_db.id
}

output "guid" {
  description = "Enterprise DB instance guid"
  value       = ibm_database.enterprise_db.guid
}

output "version" {
  description = "Enterprise DB instance version"
  value       = ibm_database.enterprise_db.version
}

output "crn" {
  description = "Enterprise DB instance crn"
  value       = ibm_database.enterprise_db.resource_crn
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = local.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = local.service_credentials_object
  sensitive   = true
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict Enterprise DB"
  value       = module.cbr_rule[*].rule_id
}

output "adminuser" {
  description = "Database admin user name"
  value       = ibm_database.enterprise_db.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = data.ibm_database_connection.database_connection.postgres[0].hosts[0].hostname
}

output "port" {
  description = "Database connection port"
  value       = data.ibm_database_connection.database_connection.postgres[0].hosts[0].port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = data.ibm_database_connection.database_connection.postgres[0].certificate[0].certificate_base64
  sensitive   = true
}
