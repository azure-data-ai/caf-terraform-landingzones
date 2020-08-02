# Machine Learning Workload

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "dap_automl_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Subnet for Machine Learning Compute
resource "azurerm_subnet" "automl_subnet" {
  name                      = var.subnet_name
  resource_group_name       = var.dap_vnet.resource_group_name
  virtual_network_name      = var.dap_vnet.name
  address_prefixes          = var.subnet_address

  depends_on = [var.dap_vnet]
}

# Insight ID for ML Workspace
resource "azurerm_application_insights" "ml_workspace_insight" {
  name                = var.application_insights
  location            = azurerm_resource_group.dap_automl_rg.location
  resource_group_name = azurerm_resource_group.dap_automl_rg.name
  application_type    = "web"
}

# Keyvault for ML Workspace
resource "azurerm_key_vault" "ml_workspace_keyvault" {
  name                = var.key_vault
  location            = azurerm_resource_group.dap_automl_rg.location
  resource_group_name = azurerm_resource_group.dap_automl_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku
}

# ML Workspace
resource "azurerm_machine_learning_workspace" "dap_ml_workspace" {
  name                    = var.workspace
  location                = azurerm_resource_group.dap_automl_rg.location
  resource_group_name     = azurerm_resource_group.dap_automl_rg.name
  application_insights_id = azurerm_application_insights.ml_workspace_insight.id
  key_vault_id            = azurerm_key_vault.ml_workspace_keyvault.id
  storage_account_id      = var.storage_account.id

  identity {
    type = "SystemAssigned"
  }

   depends_on = [
    var.storage_account,
    azurerm_key_vault.ml_workspace_keyvault,
    azurerm_application_insights.ml_workspace_insight,
    azurerm_subnet.automl_subnet
  ]
}