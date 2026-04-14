resource "azurerm_storage_account" "aml" {
  name                     = "ukweatheramlstore"
  resource_group_name      = azurerm_resource_group.weather.name
  location                 = "uksouth"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_application_insights" "weather" {
  name                = var.app_insights_name
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.weather.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [workspace_id]
  }
}

resource "azurerm_machine_learning_workspace" "weather" {
  name                    = var.aml_workspace_name
  location                = "uksouth"
  resource_group_name     = azurerm_resource_group.weather.name
  application_insights_id = azurerm_application_insights.weather.id
  key_vault_id            = azurerm_key_vault.weather.id
  storage_account_id      = azurerm_storage_account.aml.id
  tags                    = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aml_storage" {
  scope                = azurerm_storage_account.weather.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.weather.identity[0].principal_id
  depends_on           = [azurerm_machine_learning_workspace.weather]
}

resource "azurerm_role_assignment" "aml_own_storage" {
  scope                = azurerm_storage_account.aml.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.weather.identity[0].principal_id
  depends_on           = [azurerm_machine_learning_workspace.weather]
}

resource "azurerm_machine_learning_compute_cluster" "weather" {
  name                          = "weather-compute-dev"
  location                      = "uksouth"
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