# ============================================================
# UK Weather Intelligence Platform
# monitoring.tf — Alerts for pipeline and ML failures
# ============================================================

resource "azurerm_monitor_action_group" "weather" {
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.weather.name
  short_name          = "wx-alerts"
  tags                = var.tags

  email_receiver {
    name          = "email-samuel"
    email_address = var.alert_email
  }
}

# ── Alert 1: ADF pipeline failure ────────────────────────────
resource "azurerm_monitor_metric_alert" "adf_pipeline_failed" {
  name                = var.alert_rule_name
  resource_group_name = azurerm_resource_group.weather.name
  scopes              = [azurerm_data_factory.weather.id]
  description         = "Fires when weather ingestion pipeline fails"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "PipelineFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "Name"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.weather.id
  }
}

# ── Alert 2: API call failures ────────────────────────────────
resource "azurerm_monitor_metric_alert" "api_failures" {
  name                = "alert-weather-api-failures-dev"
  resource_group_name = azurerm_resource_group.weather.name
  scopes              = [azurerm_data_factory.weather.id]
  description         = "Fires when API copy activities fail"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "ActivityFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 3

    dimension {
      name     = "Name"
      operator = "Include"
      values   = ["get_current_weather", "get_air_quality"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.weather.id
  }
}