variable "resource_group_name" {
    default = "dap_automl_rg"
}

variable "location" {
    default = "southeastasia"
}

variable "application_insights" {
    default = "ml_workspace_insight_434554"
}

variable "key_vault" {
    default = "mlwkspckeyvault"
}

variable "key_vault_sku" {
    default = "standard"
}

variable "workspace" {
    default = "dap_ml_workspace"
}

variable "storage_account" {}

variable "dap_vnet" {}

variable "subnet_name" {
    default = "automl_subnet"
}

variable "subnet_address" {
    default = ["10.0.64.0/19"]
}