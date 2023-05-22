##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "EDB instance id"
  value       = ibm_database.enterprise_db.id
}

output "guid" {
  description = "EDB instance guid"
  value       = ibm_database.enterprise_db.guid
}

output "version" {
  description = "EDB instance version"
  value       = ibm_database.enterprise_db.version
}

output "crn" {
  description = "EDB instance crn"
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
  description = "CBR rule ids created to restrict EDB"
  value       = module.cbr_rule[*].rule_id
}
