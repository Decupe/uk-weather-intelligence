# ============================================================
# UK Weather Intelligence Platform
# synapse.tf — Serverless SQL for Power BI serving
# ============================================================

resource "azurerm_synapse_workspace" "weather" {
  name                                 = var.synapse_name
  resource_group_name                  = azurerm_resource_group.weather.name
  location                             = azurerm_resource_group.weather.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.synapse.id
  sql_administrator_login              = "sqladmin"
  sql_administrator_login_password     = "WeatherPlatform@2026!"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ── Synapse → ADLS Gen2 (read Gold layer) ────────────────────
resource "azurerm_role_assignment" "synapse_storage" {
  scope                = azurerm_storage_account.weather.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.weather.identity[0].principal_id
  depends_on           = [azurerm_synapse_workspace.weather]
}

resource "azurerm_synapse_firewall_rule" "azure_services" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.weather.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

resource "azurerm_synapse_firewall_rule" "local_machine" {
  name                 = "AllowLocalDevelopment"
  synapse_workspace_id = azurerm_synapse_workspace.weather.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}