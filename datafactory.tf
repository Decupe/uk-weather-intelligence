# ============================================================
# UK Weather Intelligence Platform
# datafactory.tf — ADF for API ingestion orchestration
# ============================================================

resource "azurerm_data_factory" "weather" {
  name                = var.adf_name
  location            = azurerm_resource_group.weather.location
  resource_group_name = azurerm_resource_group.weather.name

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ── ADF → ADLS Gen2 (write Bronze API data) ──────────────────
resource "azurerm_role_assignment" "adf_storage" {
  scope                = azurerm_storage_account.weather.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.weather.identity[0].principal_id
  depends_on           = [azurerm_data_factory.weather]
}

# ── ADF → Key Vault (read API key secret) ────────────────────
resource "azurerm_role_assignment" "adf_kv" {
  scope                = azurerm_key_vault.weather.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.weather.identity[0].principal_id
  depends_on           = [azurerm_data_factory.weather]
}