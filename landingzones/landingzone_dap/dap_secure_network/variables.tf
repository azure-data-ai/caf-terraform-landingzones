# Resource Group Config
variable "resource_group_name" {
    default = "dap_network_rg"
}

variable "location" {
    default = "southeastasia"
}

variable "environment" {
    default = "DEV"
}

variable "country" {
    default = "Singapore"
}

# Network Config

variable "dap_vnet_name" {
    default = "project_dap_vnet"
}

variable vnet_address_space {
  default = ["10.0.0.0/16"]
}

variable "gateway_subnet" {
    default = "gtwy_subnet"
}

variable "gateway_subnet_address" {
    default = ["10.0.0.0/19"]
}

# VM Config

variable "vm_network_interface" {
    default = "gtwy_vm_nic"
}

variable "gateway_vm" {
    default = "jumpserver-vm"
}

variable "vm_size" {
    default = "Standard_D4s_v3"
}

variable "os_computer_name" {
    default = "jumpserver-vm"
}

variable "os_adminuser" {
    default = "AzureUser"
}

variable "os_password" {
    default = "AzurePass@123"
}

variable "vm_managed_disk_type" {
    default = "StandardSSD_LRS"
}

