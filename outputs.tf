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

output "hostname" {
  description = "Database hostname"
  value       = flatten(data.ibm_database_connection.database_connection[*].postgres[*].hosts[*].hostname)
}

output "port" {
  description = "Database port"
  value       = flatten(data.ibm_database_connection.database_connection[*].postgres[*].hosts[*].port)
}
