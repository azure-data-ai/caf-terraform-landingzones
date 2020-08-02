## Parameter value assignment

shared_services_vnet = {
        vnet = {
            name                = "dap-vnet-gtw"
            address_space       = ["10.0.0.0/16"]    
            #dns                 = ["192.168.0.16", "192.168.0.64"]
        }
        specialsubnets     = {
                AzureFirewallSubnet = {
                name                = "AzureFirewallSubnet"
                cidr                = ["10.0.0.0/19"]
               }
            }
        subnets = {
            Subnet_gtw        = {
                name                = "Gateway_VM"
                cidr                = ["10.0.32.0/19"]
                service_endpoints   = []
                nsg_name            = "gateway_vm_nsg"
                nsg                 = [
                     {
                         name = "W32Time",
                         priority = "100"
                         direction = "Inbound"
                         access = "Allow"
                         protocol = "UDP"
                         source_port_range = "*"
                         destination_port_range = "123"
                         source_address_prefix = "*"
                         destination_address_prefix = "*"
                     }
                    ]
            }
            Subnet_storage             = {
                name                = "Datalake"
                cidr                = ["10.0.64.0/19"]
                service_endpoints   = ["Microsoft.Storage"]
                nsg_name            = "datalake_nsg"
            }
            Subnet_ml       = {
                name                = "Ml_Workspace"
                cidr                = ["10.0.96.0/19"]
                service_endpoints   = ["Microsoft.Storage", "Microsoft.KeyVault"]
                nsg_name            = "Ml_Workspace_nsg"
            }
            Subnet_synapse       = {
                name                = "Synpase_Workspace"
                cidr                = ["10.0.128.0/19"]
                service_endpoints   = ["Microsoft.Storage"]
                nsg_name            = "Synapse_Workspace_nsg"
            }
        }
        /* netwatcher = {
            create = true
            #create the network watcher for a subscription and for the location of the vnet
            name   = "nwdap"
            #name of the network watcher to be created

            flow_logs_settings = {
                enabled = true
                retention = true
                period = 7
            }

            traffic_analytics_settings = {
                enabled = true
            }
        } */

        diagnostics = {
            log = [
                # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                ["VMProtectionAlerts", true, true, 60], 
            ]
            metric = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                  ["AllMetrics", true, true, 60],
            ]
        }
}


vm_config = {
    vm_nic_name = "gtw-vm-nic"
    vm_name = "jump-server"
    vm_size = "Standard_D4s_v3"
    os = "Windows"
    os_profile = {
        computer_name  = "jump-svr"
        admin_username = "AzureUser"
        admin_password = "AzurePass@123"
    }

    storage_image_reference = {
        publisher = "microsoft-dsvm"
        offer     = "dsvm-windows"
        sku       = "server-2019"
        version   = "latest"
    }

    storage_os_disk = {
        #name              = "${var.os_computer_name}-vm-osdisk"
        name              = "jump-vm-osdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "StandardSSD_LRS"
        disk_size_gb      = "128"
    }
}


  akv_config = {
    name       = "akvmlwkspc"
    akv_features = {
        enabled_for_disk_encryption = true
        enabled_for_deployment      = false
        enabled_for_template_deployment = true
        soft_delete_enabled = false   # Set true in Production
        purge_protection_enabled = false # Set true in Production
    }
    #akv_features is optional

    sku_name = "premium"
    network_acls = {
         bypass = "AzureServices"
         default_action = "Deny"
    }
    #network_acls is optional

    diagnostics = {
        log = [
                # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                ["AuditEvent", true, true, 60],
            ]
        metric = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                  ["AllMetrics", true, true, 60],
            ]       
    }
}


datalake_config = {
    resource_group_name       = "dl-storage"
    storage_account = {
        name                      = "datalakestorage"
	    account_tier	          = "Standard"
	    account_kind 	          = "StorageV2"
	    account_replication_type  = "LRS"
	    access_tier 	 		  = "HOT"
	    enable_https_traffic_only = true
	    is_hns_enabled            = false

        network_rules = {
            default_action             = "Deny"
		    bypass                     = ["AzureServices"]
            #virtual_network_subnet_ids = ["Datalake"]
        }
	#network_rules is optional
    }
}


aml_config = {
    resource_group_name       = "dap-automl"
    workspace_name            = "ml-wrkspc44"
    application_insights_name = "ml-app-insht44"
  
    storage_account = {
        name                      = "amlstorage"
	    account_tier	          = "Standard"
	    account_kind 	          = "StorageV2"
	    account_replication_type  = "LRS"
	    access_tier 	 		  = "HOT"
	    enable_https_traffic_only = true
	    is_hns_enabled            = false

        network_rules = {
            default_action             = "Deny"
		    bypass                     = ["AzureServices"]
            #virtual_network_subnet_ids = ["Datalake"]
        }
	#network_rules is optional
    }
}


synapse_config = {
    resource_group_name       = "dap-synapse"
    workspace_name                = "synapsewrkspce"
    workspace_tags                = "{\"Type\": \"Data Warehouse\", \"environment\": \"DEV\", \"project\": \"myproject\"}"
    sqlserver_admin_login         = "sqladminuser"
    sqlserver_admin_password      = "azureuser@123"

    storage_account = {
        name                      = "synapsestorage"
	    account_tier	          = "Standard"
	    account_kind 	          = "StorageV2"
	    account_replication_type  = "LRS"
	    access_tier 	 		  = "HOT"
	    enable_https_traffic_only = true
	    is_hns_enabled            = true   ## Must enabled for synpase

        network_rules = {
            default_action             = "Deny"
		    bypass                     = ["AzureServices"]
            #virtual_network_subnet_ids = ["Datalake"]
        }
	#network_rules is optional
    }
}

  