# Create Azure Synpase Analytics with ARM template

resource "azurerm_resource_group" "dap_anaytics_rg" {
  name     = "dap_anaytics_rg"
  location = "southeastasia"
}

/* module "caf-resource-group" {
  source  = "aztfmod/caf-resource-group/azurerm"
  version = "0.1.3"
  # insert the 3 required variables here
  prefix                  = var.prefix
  resource_groups         = var.resource_groups.synapse.name
  tags                    = var.tags
} */

# Subnet for Synapse Workspace
/* resource "azurerm_subnet" "anaytics_subnet" {
  name                      = "anaytics_subnet"
  resource_group_name       = azurerm_resource_group.anaytics_subnet.name
  virtual_network_name      = azurerm_virtual_network.dp_vnet.name
  address_prefixes          = ["10.0.96.0/19"]
  service_endpoints         = ["Microsoft.Storage"]
} */

resource "azurerm_template_deployment" "synapse" {
  name                = "project-name-synapse"
  resource_group_name = azurerm_resource_group.dap_anaytics_rg.name

  template_body = file("${path.module}/synapse_workspace.json")

  parameters = {
    "name" = "dpworkspace4355" 
    #"location" = "southeastasia" 
    "managedVirtualNetwork" = "default"
    
    "sqlAdministratorLogin" = "sqladminuser"
    "sqlAdministratorLoginPassword" = "azureuser@123"
    "grantWorkspaceIdentityControlForSql" = "Enabled"

    "defaultDataLakeStorageAccountName" = "rsstoragedemofs"
    "defaultDataLakeStorageFilesystemName" = "container-1"
    "storageResourceGroupName" = "rsResourceGroup"
    
    "tagValues" = "{\"Type\": \"Data Warehouse\", \"environment\": \"DEV\", \"project\": \"myproject\"}"

   # "setWorkspaceIdentityRbacOnStorageAccount" = true
   # "allowAllConnections" = true
    
   # "storageSubscriptionID" = "554ea54f-e23b-400a-959a-3dc723072984"
    
   
  #  "storageRoleUniqueId" = "cec4173f-aff3-4410-8920-a7b36783b028"
  #  "isNewStorageAccount" = false
  #  "isNewFileSystemOnly" = false
   # "adlaResourceId" = ""
   # "storageAccessTier" = "Hot"
  #  "storageAccountType" = "Standard_RAGRS"
   # "storageSupportsHttpsTrafficOnly" = true
  #  "storageKind" = "StorageV2"
  #  "storageIsHnsEnabled" = true
  #  "userObjectId" = "79ebd23e-2c91-4446-860f-aa087fa12bb4"
  #  "setSbdcRbacOnStorageAccount" = false

  }
  
  deployment_mode = "Incremental"
}
