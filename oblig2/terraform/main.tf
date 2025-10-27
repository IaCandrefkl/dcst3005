resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_storage_account" "sa" {
  name                = "st${var.project_name}${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = var.account_tier
  account_replication_type = var.replication_type

  min_tls_version = "TLS1_2"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
