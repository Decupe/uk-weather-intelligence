# ============================================================
# UK Weather Intelligence Platform
# storage.tf — ADLS Gen2 data lake
# ============================================================

resource "azurerm_storage_account" "weather" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.weather.name
  location                 = azurerm_resource_group.weather.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# ── Medallion containers ──────────────────────────────────────
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.weather.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.weather.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = azurerm_storage_account.weather.name
  container_access_type = "private"
}

# ── ML specific containers ────────────────────────────────────
resource "azurerm_storage_container" "models" {
  name                  = "models"
  storage_account_name  = azurerm_storage_account.weather.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "synapse" {
  name                  = "synapse"
  storage_account_name  = azurerm_storage_account.weather.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "mlflow" {
  name                  = "mlflow"
  storage_account_name  = azurerm_storage_account.weather.name
  container_access_type = "private"
}

# ── Synapse Gen2 filesystem ───────────────────────────────────
resource "azurerm_storage_data_lake_gen2_filesystem" "synapse" {
  name               = "synapse"
  storage_account_id = azurerm_storage_account.weather.id
  depends_on         = [azurerm_storage_account.weather]
}