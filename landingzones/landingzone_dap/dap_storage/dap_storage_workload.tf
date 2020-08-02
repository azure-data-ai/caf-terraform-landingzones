# Resource Group - Data Platform
resource "azurerm_resource_group" "dap_storage_rg" {
  name     = var.storage_resource_group
  location = var.location
}

resource "azurerm_subnet" "storage_subnet" {
  name                      = var.subnet_name
  resource_group_name       = var.dap_vnet.resource_group_name
  virtual_network_name      = var.dap_vnet.name
  address_prefixes          = var.subnet_address
  service_endpoints         = ["Microsoft.Storage"]

  ## Dependency on VNET
   depends_on = [var.dap_vnet ]
}

# ADLS Gen2 Storage account
resource "azurerm_storage_account" "data_lake_storage" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.dap_storage_rg.name
  location                  = azurerm_resource_group.dap_storage_rg.location
  account_kind              = var.storage_account_kind
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_replication_type
  access_tier               = var.storage_access_tier
  enable_https_traffic_only = true
  is_hns_enabled            = true
  
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.storage_subnet.id]
    bypass                     = ["AzureServices"]
  }

  depends_on = [
    azurerm_subnet.storage_subnet
  ]
}


# Create Azure SQL Server

# Create CosmosDB Account