# ============================================================
# UK Weather Intelligence Platform
# databricks.tf — Spark transformation + ML training
# ============================================================

resource "azurerm_databricks_workspace" "weather" {
  name                = var.databricks_name
  resource_group_name = azurerm_resource_group.weather.name
  location            = azurerm_resource_group.weather.location
  sku                 = "trial"
  tags                = var.tags
}

# ── Databricks → ADLS Gen2 ───────────────────────────────────
resource "azurerm_role_assignment" "databricks_storage" {
  scope                = azurerm_storage_account.weather.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_databricks_workspace.weather]
}