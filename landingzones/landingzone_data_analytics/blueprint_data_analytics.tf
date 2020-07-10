## calling the modules

## Network foundation
locals {
  dap_prefix = "${local.prefix}-dap"
}

resource "azurecaf_naming_convention" "rg_vnet_name" {  
  name    = "vnet"
  prefix  = local.dap_prefix
  resource_type    = "rg"
  max_length = 50
  convention  = local.global_settings.convention
}

resource "azurerm_resource_group" "rg_vnet" {
  name     = azurecaf_naming_convention.rg_vnet_name.result
  location = local.global_settings.location_map.region1
}

module "caf-virtual-network" {
  source  = "aztfmod/caf-virtual-network/azurerm"
  version = "3.0.0"
  # insert the 8 required variables here
    resource_group_name               = azurerm_resource_group.rg_vnet.name
    prefix                            = local.dap_prefix
    location                          = local.global_settings.location_map.region1
    networking_object                 = var.shared_services_vnet
    tags                              = var.tags
    diagnostics_map                   = local.caf_foundations_accounting.diagnostics_map
    log_analytics_workspace           = local.caf_foundations_accounting.log_analytics_workspace
    convention                        = local.global_settings.convention
    diagnostics_settings              = var.shared_services_vnet.diagnostics
}


module "caf-nic" {
  source  = "aztfmod/caf-nic/azurerm"
  version = "0.2.2"
  # insert the 9 required variables here
    prefix                = local.dap_prefix
    tags                  = var.tags
    location              = local.global_settings.location_map.region1
    resource_group_name   = azurerm_resource_group.rg_vnet.name

    name                  = var.vm_config.vm_nic_name
    convention            = local.global_settings.convention
    subnet_id             = module.caf-virtual-network.vnet_subnets["Gateway_VM"]
  ## default values
    #enable_ip_forwarding          = var.enable_ip_forwarding
    #internal_dns_name_label       = var.internal_dns_name_label
    #dns_servers                   = var.dns_servers
    #enable_accelerated_networking = var.enable_accelerated_networking
    #private_ip_address_allocation = var.private_ip_address_allocation
    #private_ip_address            = var.private_ip_address
    #private_ip_address_version    = var.private_ip_address_version
}

module "caf-vm" {
  source  = "aztfmod/caf-vm/azurerm"
  version = "0.1.0"
  # insert the 13 required variables here
  prefix                        = local.dap_prefix
  convention                    = "passthrough"
  name                          = var.vm_config.vm_name
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  location                      = local.global_settings.location_map.region1
  tags                          = var.tags
  network_interface_ids         = [module.caf-nic.id]
  primary_network_interface_id  = module.caf-nic.id
  os                            = var.vm_config.os
  os_profile                    = var.vm_config.os_profile
  storage_image_reference       = var.vm_config.storage_image_reference
  storage_os_disk               = var.vm_config.storage_os_disk
  vm_size                       = var.vm_config.vm_size
}


## Data Platform components

module "datalake_storage" {
  source = "./blueprint_datalake"
  
  prefix                = local.dap_prefix
  convention            = local.global_settings.convention 
  location = local.global_settings.location_map.region1
  subnet_ids = module.caf-virtual-network.vnet_subnets["Datalake"]
  datalake_config = var.datalake_config
}


module "dap_synapse_workspace" {
  source = "./blueprint_synapse"
  
  prefix                = local.dap_prefix
  convention            = local.global_settings.convention
  location = local.global_settings.location_map.region1
  synapse_config = var.synapse_config
  subnet_ids = module.caf-virtual-network.vnet_subnets["Synpase_Workspace"]
  #vnet = module.caf-virtual-network.vnet
}


module "dap_aml_workspace" {
  source = "./blueprint_machine_learning"

  prefix                = local.dap_prefix
  convention            = local.global_settings.convention
  location = local.global_settings.location_map.region1
  aml_config               = var.aml_config
  subnet_ids               = module.caf-virtual-network.vnet_subnets["Ml_Workspace"]
  akv_config               = var.akv_config
  tags                     = var.tags
  diagnostics_map          = local.caf_foundations_accounting.diagnostics_map
  log_analytics_workspace  = local.caf_foundations_accounting.log_analytics_workspace
}



###########
 















