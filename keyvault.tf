# ============================================================
# UK Weather Intelligence Platform
# keyvault.tf — Secret management
# ============================================================

resource "azurerm_key_vault" "weather" {
  name                      = var.keyvault_name
  location                  = azurerm_resource_group.weather.location
  resource_group_name       = azurerm_resource_group.weather.name
  tenant_id                 = var.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
  tags                      = var.tags
}

# ── Your user gets Key Vault Administrator ────────────────────
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.weather.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# ── ADF gets Key Vault Secrets User ──────────────────────────
resource "azurerm_role_assignment" "adf_kv_secrets" {
  scope                = azurerm_key_vault.weather.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.weather.identity[0].principal_id
  depends_on           = [azurerm_data_factory.weather]
}

# ── Databricks gets Key Vault Secrets User ───────────────────
resource "azurerm_role_assignment" "databricks_kv_secrets" {
  scope                = azurerm_key_vault.weather.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_key_vault.weather]
}

# ── AML gets Key Vault Secrets User ──────────────────────────
resource "azurerm_role_assignment" "aml_kv_secrets" {
  scope                = azurerm_key_vault.weather.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_machine_learning_workspace.weather.identity[0].principal_id
  depends_on           = [azurerm_machine_learning_workspace.weather]
}

# ── Store OpenWeatherMap API key securely ─────────────────────
resource "azurerm_key_vault_secret" "owm_api_key" {
  name         = "openweathermap-api-key"
  value        = var.owm_api_key
  key_vault_id = azurerm_key_vault.weather.id
  depends_on   = [azurerm_role_assignment.kv_admin]

  tags = {
    source      = "openweathermap.org"
    description = "Free tier API key for weather data"
    rotation    = "manual"
  }
}

# ── Store storage account key for Databricks ─────────────────
resource "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-access-key"
  value        = azurerm_storage_account.weather.primary_access_key
  key_vault_id = azurerm_key_vault.weather.id
  depends_on   = [azurerm_role_assignment.kv_admin]
}