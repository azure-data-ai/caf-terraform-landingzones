# Map of the remote data state
variable "lowerlevel_storage_account_name" {}
variable "lowerlevel_container_name" {}
variable "lowerlevel_key" {}                  # Keeping the key for the lower level0 access
variable "lowerlevel_resource_group_name" {}
variable "workspace" {}
variable "tags" {
    type = map
    default = {
        "environment": "DEV"
        "project"    : "my_analytics_project"
    }
}

##----Rahul-----

variable "shared_services_vnet" {
 description = "network object"
}

variable "vm_config" {
    description = "Virtual Machine Configuration"
}

variable "akv_config" {
  description = "(Required) Key Vault Configuration Object"
}

variable "datalake_config" {}

variable "aml_config" {}

variable "synapse_config" {}



