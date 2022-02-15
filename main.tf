data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = var.resource_group
}

data "azurerm_key_vault" "this" {
  count               = var.create_key_vault ? 0 : 1
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_key_vault" "this" {
  count                           = var.create_key_vault ? 1 : 0
  name                            = var.name
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = var.location == null ? data.azurerm_resource_group.this.location : var.location
  sku_name                        = lower(var.sku_name)
  tenant_id                       = var.tenant_id == null ? data.azurerm_client_config.current.tenant_id : var.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id               = lookup(access_policy.value, "tenant_id", data.azurerm_client_config.current.tenant_id)
      object_id               = lookup(access_policy.value, "object_id", data.azurerm_client_config.current.object_id)
      application_id          = lookup(access_policy.value, "application_id", null)
      key_permissions         = lookup(access_policy.value, "key_permissions", "") == "" ? null : split(",", access_policy.value.key_permissions)
      secret_permissions      = lookup(access_policy.value, "secret_permissions", "") == "" ? null : split(",", access_policy.value.secret_permissions)
      certificate_permissions = lookup(access_policy.value, "certificate_permissions", "") == "" ? null : split(",", access_policy.value.certificate_permissions)
      storage_permissions     = lookup(access_policy.value, "storage_permissions", "") == "" ? null : split(",", access_policy.value.storage_permissions)
    }
  }

  dynamic "contact" {
    for_each = var.contacts
    content {
      email = contact.value.email
      name  = lookup(contact.value, "name", null)
      phone = lookup(contact.value, "phone", null)
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_key" "vault" {
  for_each        = { for key in var.keys : key.name => key }
  key_vault_id    = var.create_key_vault ? azurerm_key_vault.this[0].id : data.azurerm_key_vault.this[0].id
  name            = each.value.name
  key_type        = each.value.key_type
  key_size        = lookup(each.value, "key_size", null)
  curve           = lookup(each.value, "curve", null)
  key_opts        = lookup(each.value, "key_opts", "") == "" ? null : split(",", each.value.key_opts)
  not_before_date = lookup(each.value, "not_before_date", null)
  expiration_date = lookup(each.value, "expiration_date", null)
}

resource "azurerm_key_vault_secret" "vault" {
  for_each        = { for secret in var.secrets : secret.name => secret }
  key_vault_id    = var.create_key_vault ? azurerm_key_vault.this[0].id : data.azurerm_key_vault.this[0].id
  name            = each.value.name
  value           = each.value.value
  content_type    = lookup(each.value, "content_type", null)
  not_before_date = lookup(each.value, "not_before_date", null)
  expiration_date = lookup(each.value, "expiration_date", null)
}
