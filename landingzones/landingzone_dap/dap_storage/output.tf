output "dap_datalake_storage" {
  value = azurerm_storage_account.data_lake_storage
  description = "Storage setting of the data platform"
}