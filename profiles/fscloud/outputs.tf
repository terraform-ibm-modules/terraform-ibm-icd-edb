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

output "hostname" {
  description = "Enterprise DB instance hostname"
  value       = module.enterprise_db.hostname
}

output "port" {
  description = "Enterprise DB instance port"
  value       = module.enterprise_db.port
}
