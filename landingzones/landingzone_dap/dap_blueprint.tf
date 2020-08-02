# Create Subnet 

# Stream Analytics

# Eventhub

/* module "dap_network_topology" {
  source = "./dap_secure_network"
}

module "dap_storage" {
  source = "./dap_storage"

  #global_settings = local.global_settings
  dap_vnet = module.dap_network_topology.dap_network_vnet
  #vnet_resource_group = module.dap_network_topology.dap_network_vnet.resource_group_name
  location = local.global_settings.location_map.region1
}

module "dap_ml_workspace" {
  source = "./dap_auto_ml"

  dap_vnet = module.dap_network_topology.dap_network_vnet
  location = local.global_settings.location_map.region1
  storage_account = module.dap_storage.dap_datalake_storage
} */

module "dap_analytics_workspace" {
  source = "./dap_synapse_analytics"

 /*  prefix     = "${local.prefix}dap-"
  resource_groups = {
    synapse       = { 
                    name     = "synapse-anaytics-rg"
                    location = "southeastasia" 
    }
  } */

}

