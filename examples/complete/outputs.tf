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

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict Enterprise DB"
  value       = module.enterprise_db.cbr_rule_ids
}
