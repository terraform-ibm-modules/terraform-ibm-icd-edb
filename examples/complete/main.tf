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
# Key Protect All Inclusive
##############################################################################

locals {
  data_key_name    = "${var.prefix}-enterprisedb"
  backups_key_name = "${var.prefix}-enterprisedb-backups"
}

module "key_protect_all_inclusive" {
  source            = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version           = "5.1.7"
  resource_group_id = module.resource_group.resource_group_id
  # Note: Database instance and Key Protect must be created in the same region when using BYOK
  # See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok
  region                    = var.region
  key_protect_instance_name = "${var.prefix}-kp"
  resource_tags             = var.resource_tags
  keys = [
    {
      key_ring_name = "icd"
      keys = [
        {
          key_name     = local.data_key_name
          force_delete = true
        },
        {
          key_name     = local.backups_key_name
          force_delete = true
        }
      ]
    }
  ]
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
# EDB Instance
##############################################################################

module "enterprise_db" {
  source            = "../../"
  resource_group_id = module.resource_group.resource_group_id
  name              = "${var.prefix}-edb"
  region            = var.region
  edb_version       = var.edb_version
  admin_pass        = var.admin_pass
  users             = var.users
  tags              = var.resource_tags
  # Example of how to use different KMS keys for data and backups
  use_ibm_owned_encryption_key = false
  use_same_kms_key_for_backups = false
  kms_key_crn                  = module.key_protect_all_inclusive.keys["icd.${local.data_key_name}"].crn
  backup_encryption_key_crn    = module.key_protect_all_inclusive.keys["icd.${local.backups_key_name}"].crn
  service_credential_names = {
    "enterprisedb_admin" : "Administrator",
    "enterprisedb_operator" : "Operator",
    "enterprisedb_viewer" : "Viewer",
    "enterprisedb_editor" : "Editor",
  }
  access_tags        = var.access_tags
  member_host_flavor = "b3c.4x16.encrypted"
  configuration = {
    max_connections = 250
  }
  cbr_rules = [
    {
      description      = "${var.prefix}-edb access only from vpc"
      enforcement_mode = "enabled" # EDB does not support report mode
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

# VPE provisioning should wait for the database provisioning
resource "time_sleep" "wait_120_seconds" {
  depends_on      = [module.enterprise_db]
  create_duration = "120s"
}

##############################################################################
# VPE
##############################################################################

resource "ibm_is_security_group" "sg1" {
  name = "${var.prefix}-sg1"
  vpc  = ibm_is_vpc.example_vpc.id
}

resource "ibm_is_virtual_endpoint_gateway" "edbvpe" {
  name = "${var.prefix}-vpe-to-edb"
  target {
    crn           = module.enterprise_db.crn
    resource_type = "provider_cloud_service"
  }
  vpc = ibm_is_vpc.example_vpc.id
  ips {
    subnet = ibm_is_subnet.testacc_subnet.id
    name   = "${var.prefix}-edb-access-reserved-ip"
  }
  resource_group  = module.resource_group.resource_group_id
  security_groups = [ibm_is_security_group.sg1.id]
  depends_on = [
    time_sleep.wait_120_seconds,
    time_sleep.wait_30_seconds
  ]
}

# wait 30 secs after security group is destroyed before destroying VPE to workaround race condition
resource "time_sleep" "wait_30_seconds" {
  depends_on       = [ibm_is_security_group.sg1]
  destroy_duration = "30s"
}
