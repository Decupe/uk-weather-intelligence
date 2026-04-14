# ============================================================
# UK Weather Intelligence Platform
# variables.tf
# ============================================================

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "uk-weather-dev"
}

variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "uk-weather"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "uk-weather"
    owner       = "samuel-igwilo"
    managed_by  = "terraform"
  }
}

# ── Resource names ────────────────────────────────────────────
variable "storage_account_name" {
  description = "ADLS Gen2 storage account name"
  type        = string
  default     = "ukweatherstorage"
}

variable "adf_name" {
  description = "Azure Data Factory name"
  type        = string
  default     = "uk-weather-adf"
}

variable "keyvault_name" {
  description = "Key Vault name"
  type        = string
  default     = "uk-weather-kv"
}

variable "databricks_name" {
  description = "Databricks workspace name"
  type        = string
  default     = "uk-weather-databricks"
}

variable "synapse_name" {
  description = "Synapse Analytics workspace name"
  type        = string
  default     = "uk-weather-synapse"
}

variable "aml_workspace_name" {
  description = "Azure Machine Learning workspace name"
  type        = string
  default     = "uk-weather-aml"
}

variable "app_insights_name" {
  description = "Application Insights name"
  type        = string
  default     = "uk-weather-appinsights"
}

variable "action_group_name" {
  description = "Monitor action group name"
  type        = string
  default     = "ag-weather-alerts-dev"
}

variable "alert_rule_name" {
  description = "Monitor alert rule name"
  type        = string
  default     = "alert-weather-pipeline-failed-dev"
}

# ── API configuration ─────────────────────────────────────────
variable "owm_api_key" {
  description = "OpenWeatherMap API key"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address for pipeline alerts"
  type        = string
  default     = "igwiloprecious806@gmail.com"
}