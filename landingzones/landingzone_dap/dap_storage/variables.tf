
variable "dap_vnet" {}

#variable "vnet_resource_group" {}

variable "storage_resource_group" {
    default = "dap_storage_rg"
}

variable "storage_account_name" {
    default = "datalakestorageacct22"
}

variable "subnet_address" {
    default = ["10.0.32.0/19"]
}

variable "subnet_name" {
    default = "project_storage_subnet"
}

variable "location" {
    default = "southeastasia"
}

variable "storage_account_tier" {
    default = "Standard"
}

variable "storage_account_kind" {
    default = "StorageV2"
}

variable "storage_replication_type" {
    default = "LRS"
}

variable "storage_access_tier" {
    default = "HOT"
}