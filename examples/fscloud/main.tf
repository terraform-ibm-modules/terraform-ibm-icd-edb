##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.2.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Get Cloud Account ID
##############################################################################

data "ibm_iam_account_settings" "iam_account_settings" {
}

##############################################################################
# VPC
##############################################################################
resource "ibm_is_vpc" "example_vpc" {
  name           = "${var.prefix}-vpc"
  resource_group = module.resource_group.resource_group_id
  tags           = var.resource_tags
}

resource "ibm_is_subnet" "testacc_subnet" {
  name                     = "${var.prefix}-subnet"
  vpc                      = ibm_is_vpc.example_vpc.id
  zone                     = "${var.region}-1"
  total_ipv4_address_count = 256
  resource_group           = module.resource_group.resource_group_id
}

##############################################################################
# Create CBR Zone
##############################################################################
module "cbr_zone" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.31.0"
  name             = "${var.prefix}-VPC-network-zone"
  zone_description = "CBR Network zone representing VPC"
  account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
  addresses = [{
    type  = "vpc", # to bind a specific vpc to the zone
    value = ibm_is_vpc.example_vpc.crn,
  }]
}

##############################################################################
# Enterprise DB Instance
##############################################################################

module "enterprise_db" {
  source                    = "../../modules/fscloud"
  resource_group_id         = module.resource_group.resource_group_id
  name                      = "${var.prefix}-edb"
  region                    = var.region
  edb_version               = var.edb_version
  tags                      = var.resource_tags
  kms_key_crn               = var.kms_key_crn
  backup_encryption_key_crn = var.backup_encryption_key_crn
  backup_crn                = var.backup_crn
  service_credential_names = {
    "enterprisedb_admin" : "Administrator",
    "enterprisedb_operator" : "Operator",
    "enterprisedb_viewer" : "Viewer",
    "enterprisedb_editor" : "Editor",
  }
  auto_scaling = {
    disk = {
      capacity_enabled : true,
      io_enabled : true
    }
    memory = {
      io_enabled : true,
    }
  }
  member_host_flavor = "b3c.4x16.encrypted"
  access_tags        = var.access_tags
  cbr_rules = [
    {
      description      = "${var.prefix}-edb access only from vpc"
      enforcement_mode = "enabled" # Enterprise DB does not support report mode
      account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
      rule_contexts = [{
        attributes = [
          {
            "name" : "endpointType",
            "value" : "private"
          },
          {
            name  = "networkZoneId"
            value = module.cbr_zone.zone_id
        }]
      }]
    }
  ]
}
