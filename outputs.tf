# ============================================================
# UK Weather Intelligence Platform
# outputs.tf — Values displayed after terraform apply
# ============================================================

output "resource_group_name" {
  value = azurerm_resource_group.weather.name
}

output "storage_account_name" {
  value = azurerm_storage_account.weather.name
}

output "adf_name" {
  value = azurerm_data_factory.weather.name
}

output "adf_identity" {
  value = azurerm_data_factory.weather.identity[0].principal_id
}

output "keyvault_name" {
  value = azurerm_key_vault.weather.name
}

output "keyvault_uri" {
  value = azurerm_key_vault.weather.vault_uri
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.weather.workspace_url
}

output "synapse_workspace_name" {
  value = azurerm_synapse_workspace.weather.name
}

output "synapse_sql_endpoint" {
  value = "uk-weather-synapse-ondemand.sql.azuresynapse.net"
}

output "aml_workspace_name" {
  value = azurerm_machine_learning_workspace.weather.name
}

output "aml_workspace_id" {
  value = azurerm_machine_learning_workspace.weather.id
}

output "app_insights_connection_string" {
  value     = azurerm_application_insights.weather.connection_string
  sensitive = true
}

output "api_key_secret_name" {
  value       = azurerm_key_vault_secret.owm_api_key.name
  description = "Key Vault secret name for OpenWeatherMap API key"

}
output "aml_storage_account_name" {
  value       = azurerm_storage_account.aml.name
  description = "Separate storage for AML (no HNS - required by AML)"
}