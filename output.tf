output "id" {
  description = "The ID of the Key Vault"
  value       = var.create_key_vault ? azurerm_key_vault.this[0].id : data.azurerm_key_vault.this[0].id
}

output "name" {
  description = "The name of the Key Vault"
  value       = var.create_key_vault ? azurerm_key_vault.this[0].name : data.azurerm_key_vault.this[0].name
}

output "tenant_id" {
  description = "The name of the Key Vault"
  value        = var.create_key_vault ? azurerm_key_vault.this[0].tenant_id : data.azurerm_key_vault.this[0].tenant_id
}

output "uri" {
  description = "The URI of the Key Vault, used for performing operations on keys and secrets"
  value       = var.create_key_vault ? azurerm_key_vault.this[0].vault_uri : data.azurerm_key_vault.this[0].vault_uri
}
output "resource_group" {
  description = "The resource group of the Key Vault"
  value       = data.azurerm_resource_group.this.name
}

output "location" {
  value       = var.create_key_vault ? azurerm_key_vault.this[0].location : data.azurerm_key_vault.this[0].location
  description = "The location/region where the key vault is created."
}
output "access_policies" {
  value       = azurerm_key_vault.this[0].access_policy
  description = "Blocks containing configuration of each access policy."
}
output "keys" {
  value       = azurerm_key_vault.this[0].access_policy
  description = "Blocks containing configuration of each key."
}
output "secrets" {
  value       = azurerm_key_vault.this[0].access_policy
  description = "Blocks containing configuration of each secret."
}
output "contacts" {
  value       = azurerm_key_vault.this[0].contact
  description = "Blocks containing each contact."
}
output "tags" {
  value       = azurerm_key_vault.this[0].tags
  description = "The tags assigned to the resource."
}
