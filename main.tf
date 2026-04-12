# ============================================================
# UK Weather Intelligence Platform
# main.tf — Provider configuration
# ============================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.30"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

# Read current Azure login identity
data "azurerm_client_config" "current" {}

# ── Resource Group ────────────────────────────────────────────
resource "azurerm_resource_group" "weather" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}