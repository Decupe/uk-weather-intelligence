# ============================================================
# UK Weather Intelligence Platform
# machine_learning.tf — Azure ML for temperature prediction
# NOTE: AML requires a separate NON-HNS storage account
# ADLS Gen2 (HNS enabled) is NOT supported by AML directly
# ============================================================

# ── Separate storage account for AML (no HNS) ────────────────
resource "azurerm_storage_account" "aml" {
  name                     = "ukweatheramlstore"
  resource_group_name      = azurerm_resource_group.weather.name
  location                 = azurerm_resource_group.weather.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# ── Application Insights (required by AML) ───────────────────
resource "azurerm_application_insights" "weather" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.weather.location
  resource_group_name = azurerm_resource_group.weather.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [workspace_id]
  }
}

# ── Azure Machine Learning Workspace ─────────────────────────
resource "azurerm_machine_learning_workspace" "weather" {
  name                    = var.aml_workspace_name
  location                = azurerm_resource_group.weather.location
  resource_group_name     = azurerm_resource_group.weather.name
  application_insights_id = azurerm_application_insights.weather.id
  key_vault_id            = azurerm_key_vault.weather.id
  storage_account_id      = azurerm_storage_account.aml.id
  tags                    = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# ── AML → ADLS Gen2 (read Gold features, write predictions) ──
resource "azurerm_role_assignment" "aml_storage" {
  scope                = azurerm_storage_account.weather.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.weather.identity[0].principal_id
  depends_on           = [azurerm_machine_learning_workspace.weather]
}

# ── AML → AML storage (its own internal storage) ─────────────
resource "azurerm_role_assignment" "aml_own_storage" {
  scope                = azurerm_storage_account.aml.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.weather.identity[0].principal_id
  depends_on           = [azurerm_machine_learning_workspace.weather]
}

# ── AML Compute cluster for model training ────────────────────
resource "azurerm_machine_learning_compute_cluster" "weather" {
  name                          = "weather-compute-dev"
  location                      = azurerm_resource_group.weather.location
  machine_learning_workspace_id = azurerm_machine_learning_workspace.weather.id
  vm_priority                   = "Dedicated"
  vm_size                       = "Standard_DS2_v2"
  tags                          = var.tags

  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 2
    scale_down_nodes_after_idle_duration = "PT15M"
  }

  identity {
    type = "SystemAssigned"
  }
}