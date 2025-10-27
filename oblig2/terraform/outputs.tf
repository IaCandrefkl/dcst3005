output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.sa.name
}

output "storage_account_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "environment" {
  description = "Deployed environment"
  value       = var.environment
}
